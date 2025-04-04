import { onRequest } from 'firebase-functions/v2/https';
import { defineSecret } from 'firebase-functions/params';
import * as admin from 'firebase-admin';
import express from 'express';
import sgMail from '@sendgrid/mail';
import cors from 'cors';

// 配置常量
const MAX_RETRIES = 3;
const RETRY_DELAY_MS = 2000;
const FUNCTION_TIMEOUT_SEC = 60;
const FUNCTION_MEMORY = '512MiB';

// 定义密钥参数
const sendgridKey = defineSecret('SENDGRID_API_KEY');
const fromEmail = defineSecret('SENDGRID_FROM_EMAIL');

// 初始化
admin.initializeApp();
const app = express();

// 中间件配置
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cors({
  origin: true,
  methods: ['POST', 'OPTIONS'],
  allowedHeaders: ['Content-Type'],
  maxAge: 86400
}));

// 健康检查端点
app.get('/healthz', (req, res) => {
  res.status(200).json({ 
    status: 'healthy',
    timestamp: new Date().toISOString()
  });
});

/**
 * 带指数退避的邮件发送重试机制
 * @param {import('@sendgrid/mail').MailDataRequired} msg - 要发送的邮件内容对象
 * @param {number} [retriesLeft=MAX_RETRIES] - 剩余重试次数，默认为MAX_RETRIES
 * @param {number} [baseDelay=RETRY_DELAY_MS] - 基础延迟时间(毫秒)，默认为RETRY_DELAY_MS
 * @returns {Promise<{success: boolean, attempts: number, error?: string}>} 返回发送结果
 */
const sendEmailWithRetry = async (
  msg: sgMail.MailDataRequired,
  retriesLeft = MAX_RETRIES,
  baseDelay = RETRY_DELAY_MS
): Promise<{ success: boolean; attempts: number; error?: string }> => {
  let lastError: unknown = null;
  
  for (let attempt = 1; attempt <= retriesLeft; attempt++) {
    try {
      const [response] = await sgMail.send(msg);
      console.log(`邮件发送成功 (尝试次数: ${attempt})`, {
        status: response.statusCode,
        headers: response.headers
      });
      return { success: true, attempts: attempt };
    } catch (error: unknown) {
      lastError = error;
      const delay = baseDelay * Math.pow(2, attempt - 1); // 指数退避
      
      let errorDetails = 'Unknown error';
      if (error instanceof Error) {
        errorDetails = error.message;
        if ('response' in error && typeof error.response === 'object' && error.response !== null) {
          const response = error.response as { body?: { errors?: unknown } };
          errorDetails += ` | ${JSON.stringify(response.body?.errors)}`;
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

// 邮件发送端点
app.post('/', async (req, res) => {
  try {
    // 请求日志记录
    const requestId = Math.random().toString(36).substring(2, 9);
    console.log(`[${requestId}] 收到请求`, {
      headers: req.headers,
      body: req.body,
      ip: req.ip
    });

    // 1. 验证请求数据
    const { email, message } = req.body;
    if (!email || !message) {
      console.warn(`[${requestId}] 参数验证失败`);
      return res.status(400).json({
        success: false,
        error: '缺少必填参数',
        required: ['email', 'message']
      });
    }

    // 2. 获取并验证配置
    const sgApiKey = sendgridKey.value();
    const senderEmail = fromEmail.value();

    if (!sgApiKey?.startsWith('SG.')) {
      throw new Error('无效的API密钥格式 (必须以SG.开头)');
    }

    // 3. 初始化SendGrid客户端
    sgMail.setApiKey(sgApiKey);

    // 4. 构造邮件
    const msg: sgMail.MailDataRequired = {
      to: "peng.zhang@n47.eu",
      from: {
        email: senderEmail,
        name: "网站通知服务" // 增加发件人名称
      },
      subject: "新邮件通知",
      text: `发件人: ${email}\n内容: ${message}`,
      html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px;">
          <h2 style="color: #333;">新邮件通知</h2>
          <p><strong>发件人:</strong> ${email}</p>
          <div style="background: #f5f5f5; padding: 15px; border-radius: 5px;">
            ${message.replace(/\n/g, '<br>')}
          </div>
          <p style="color: #999; font-size: 12px; margin-top: 20px;">
            此邮件由系统自动发送，请勿直接回复
          </p>
        </div>
      `,
      mailSettings: {
        sandboxMode: {
          enable: process.env.NODE_ENV === 'test' // 测试模式不真实发送
        }
      }
    };

    // 5. 发送邮件（带重试机制）
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
      if ('response' in error && typeof error.response === 'object' && error.response !== null) {
        const response = error.response as { body?: { errors?: unknown } };
        errorDetails += ` | ${JSON.stringify(response.body?.errors)}`;
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
  timeoutSeconds: FUNCTION_TIMEOUT_SEC,
  memory: FUNCTION_MEMORY,
  secrets: [sendgridKey, fromEmail]
}, app);