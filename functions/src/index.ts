import { onRequest } from 'firebase-functions/v2/https';
import { defineSecret } from 'firebase-functions/params';
import * as admin from 'firebase-admin';
import { getAppCheck } from 'firebase-admin/app-check';
import express from 'express';
import { Resend } from 'resend';
import cors from 'cors';

// 配置常量
const CONFIG = {
  MAX_RETRIES: 3,
  RETRY_DELAY_MS: 2000,
  FUNCTION_TIMEOUT_SEC: 60,
  FUNCTION_MEMORY: '512MiB' as const,
  ALLOWED_ORIGINS: ['https://n47.web.app', 'https://n47.eu'],
  RATE_LIMIT: {
    WINDOW_MS: 15 * 60 * 1000, // 15分钟
    MAX_REQUESTS: 100, // 每个IP每15分钟最多100次请求
  },
};

// 定义密钥参数
const resendKey = defineSecret('RESEND_API_KEY');
const fromEmail = defineSecret('RESEND_FROM_EMAIL');

// 初始化
admin.initializeApp();
const app = express();

// 内存中的简单限流缓存
const requestCounts = new Map<string, number>();

// 中间件配置
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cors({
  origin: true,
  methods: ['POST', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'X-Firebase-AppCheck'],
  maxAge: 86400
}));

// 限流中间件
app.use((req, res, next) => {
  const clientIp = req.ip || req.connection.remoteAddress || '';
  const now = Date.now();
  
  // 清理过期记录
  requestCounts.forEach((timestamp, ip) => {
    if (now - timestamp > CONFIG.RATE_LIMIT.WINDOW_MS) {
      requestCounts.delete(ip);
    }
  });

  const count = requestCounts.get(clientIp) || 0;
  if (count >= CONFIG.RATE_LIMIT.MAX_REQUESTS) {
    return res.status(429).json({
      success: false,
      error: '请求过于频繁，请稍后再试',
    });
  }

  requestCounts.set(clientIp, count + 1);
  next();
});

// App Check 验证中间件
const verifyAppCheck = async (req: express.Request, res: express.Response, next: express.NextFunction) => {
  // 健康检查端点不需要验证
  if (req.path === '/healthz') return next();

  const appCheckToken = req.header('X-Firebase-AppCheck');
  
  if (!appCheckToken) {
    console.warn('缺少AppCheck Token');
    return res.status(401).json({
      success: false,
      error: '未经授权的请求',
    });
  }

  try {
    await getAppCheck().verifyToken(appCheckToken);
    next();
  } catch (error) {
    console.error('AppCheck验证失败:', error);
    return res.status(401).json({
      success: false,
      error: '无效的AppCheck Token',
    });
  }
};

 app.use(verifyAppCheck);

// 健康检查端点
app.get('/healthz', (req, res) => {
  res.status(200).json({ 
    status: 'healthy',
    timestamp: new Date().toISOString(),
    version: process.env.K_REVISION || 'local',
  });
});

// 验证邮件内容的中间件
const validateEmailRequest = (req: express.Request, res: express.Response, next: express.NextFunction) => {
  const { name, email, subject, message } = req.body;
  
  if (!name || !email || !subject || !message) {
    return res.status(400).json({
      success: false,
      error: '缺少必填参数',
      required: ['name', 'email', 'subject', 'message']
    });
  }

  // 简单的邮箱格式验证
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!emailRegex.test(email)) {
    return res.status(400).json({
      success: false,
      error: '无效的邮箱格式',
    });
  }

  // 防止XSS攻击，清理输入
  req.body.cleanName = name.toString().substring(0, 100);
  req.body.cleanEmail = email.toString().substring(0, 100);
  req.body.cleanSubject = subject.toString().substring(0, 200);
  req.body.cleanMessage = message.toString().substring(0, 2000);
  
  next();
};

/**
 * 带指数退避的邮件发送重试机制 - 修改为使用 Resend
 * @param {object} msg - 要发送的邮件内容对象
 * @param {number} [retriesLeft=MAX_RETRIES] - 剩余重试次数，默认为MAX_RETRIES
 * @param {number} [baseDelay=RETRY_DELAY_MS] - 基础延迟时间(毫秒)，默认为RETRY_DELAY_MS
 * @returns {Promise<{success: boolean, attempts: number, error?: string}>} 返回发送结果
 */
const sendEmailWithRetry = async (
  msg: {
    from: string;
    to: string;
    subject: string;
    html: string;
    text?: string;
  },
  retriesLeft = CONFIG.MAX_RETRIES,
  baseDelay = CONFIG.RETRY_DELAY_MS
): Promise<{ success: boolean; attempts: number; error?: string }> => {
  let lastError: unknown = null;
  
  for (let attempt = 1; attempt <= retriesLeft; attempt++) {
    try {
      const resend = new Resend(resendKey.value());
      const response = await resend.emails.send(msg);
      
      console.log(`邮件发送成功 (尝试次数: ${attempt})`, {
        id: response.data?.id,
        to: msg.to
      });
      return { success: true, attempts: attempt };
    } catch (error: unknown) {
      lastError = error;
      const delay = baseDelay * Math.pow(2, attempt - 1); // 指数退避
      
      let errorDetails = 'Unknown error';
      if (error instanceof Error) {
        errorDetails = error.message;
        if (typeof error === 'object' && error !== null) {
          errorDetails += ` | ${JSON.stringify(error)}`;
        }
      }

      console.warn(`发送失败 (尝试 ${attempt}/${retriesLeft})`, {
        error: errorDetails,
        nextRetryIn: `${delay}ms`
      });

      if (attempt < retriesLeft) {
        await new Promise(resolve => setTimeout(resolve, delay));
      }
    }
  }

  if (lastError instanceof Error) {
    throw lastError;
  }
  throw new Error('Failed to send email after retries');
};

// 邮件发送端点 - 修改邮件构造部分
app.post('/', validateEmailRequest, async (req, res) => {
  try {
    // 请求日志记录
    const requestId = Math.random().toString(36).substring(2, 9);
    console.log(`[${requestId}] 收到请求`, {
      headers: req.headers,
      body: req.body,
      ip: req.ip
    });

    // 1. 验证请求数据 (由中间件处理)
    const { cleanName: name, cleanEmail: email, cleanSubject: subject, cleanMessage: message } = req.body;

    // 2. 获取配置 (Resend 不需要初始化步骤)
    const senderEmail = fromEmail.value();
    console.log('senderEmail:', senderEmail);

    // 3. 构造邮件 (Resend 格式)
    const msg = {
      from: `N47 web <${senderEmail}>`, // Resend 的 from 格式可以是 "Name <email@example.com>"
      to: "web@n47.eu",
      subject: "New email from web",
      text: `From: ${email}\nName: ${name}\n\n${message}`,
      html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px;">
          <h2 style="color: #333;">${subject}</h2>
          <p><strong>From:</strong> ${email}</p>
          <p><strong>Name:</strong> ${name}</p>
          <div style="background: #f5f5f5; padding: 15px; border-radius: 5px;">
            ${message.replace(/\n/g, '<br>')}
          </div>
          <p style="color: #999; font-size: 12px; margin-top: 20px;">
            This email is sent automatically by the system, please do not reply directly.
          </p>
        </div>
      `
    };

    // 4. 发送邮件（带重试机制）
    const { success, attempts } = await sendEmailWithRetry(msg);
    
    return res.status(200).json({
      success,
      attempts,
      requestId,
      timestamp: new Date().toISOString()
    });

  } catch (error: unknown) {
    let errorDetails = 'Unknown error';
    if (error instanceof Error) {
      errorDetails = error.message;
      if (typeof error === 'object' && error !== null) {
        errorDetails += ` | ${JSON.stringify(error)}`;
      }
    }

    console.error('邮件发送最终失败:', errorDetails);
    
    return res.status(500).json({
      success: false,
      error: '邮件发送服务不可用',
      details: process.env.NODE_ENV !== 'production' ? errorDetails : undefined,
      timestamp: new Date().toISOString()
    });
  }
});

// 404 处理
app.use((req, res) => {
  res.status(404).json({
    success: false,
    error: '端点不存在',
    availableEndpoints: ['POST /', 'GET /healthz']
  });
});

// 导出云函数
export const sendemail = onRequest({
  region: 'us-central1',
  timeoutSeconds: CONFIG.FUNCTION_TIMEOUT_SEC,
  memory: CONFIG.FUNCTION_MEMORY,
  secrets: [resendKey, fromEmail]
}, app);