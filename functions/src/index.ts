
import * as dotenv from 'dotenv';
dotenv.config(); // 必须在其他import之前调用
import functions = require('firebase-functions');
import admin = require('firebase-admin');
import sgMail = require('@sendgrid/mail');

admin.initializeApp();

export const sendEmail = functions.https.onRequest(async (req, res) => {
  // 1. 打印所有环境变量（调试用）
  functions.logger.debug('环境变量:', {
    SENDGRID_API_KEY: process.env.SENDGRID_API_KEY ? '已设置' : '未设置',
    SENDGRID_FROM_EMAIL: process.env.SENDGRID_FROM_EMAIL || '未设置',
    firebaseConfig: functions.config().sendgrid
      ? '已配置'
      : '未配置'
  });

  // 2. 获取配置（带验证）
  const sendgridKey = process.env.SENDGRID_API_KEY || functions.config()?.sendgrid?.key;
  const fromEmail = process.env.SENDGRID_FROM_EMAIL || functions.config()?.sendgrid?.from;

  if (!sendgridKey) {
    functions.logger.error('SendGrid API 密钥未配置');
    res.status(500).json({
      success: false,
      error: '服务器配置错误'
    });
    return;
  }

  if (!sendgridKey.startsWith('SG.')) {
    functions.logger.error('无效的SendGrid密钥格式:', {
      keyPrefix: sendgridKey.substring(0, 3)
    });
  }

  if (!fromEmail) {
    functions.logger.error('发件邮箱未配置');
    res.status(500).json({
      success: false,
      error: '服务器配置错误'
    });
    return;
  }

  res.set('Access-Control-Allow-Origin', '*');
  res.set('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.set('Access-Control-Allow-Headers', 'Content-Type');

  // 3. 初始化SendGrid（带验证）
  try {
    sgMail.setApiKey(sendgridKey);
    functions.logger.debug('SendGrid初始化成功', {
      fromEmail,
      keyLength: sendgridKey.length
    });
  } catch (error) {
    functions.logger.error('SendGrid初始化失败:', error);
    res.status(500).json({
      success: false,
      error: '邮件服务不可用'
    });
    return;
  }

  // 4. 处理请求（原有逻辑）
  try {
    const { email, message } = req.body;
    functions.logger.debug('收到请求:', { email, message });

    const msg = {
      to: "zhangpeng.snowboard@gmail.com",
      from: "zhangpeng.snowboard@gmail.com",
      subject: "新邮件通知",
      text: `发件人: ${email}\n\n内容: ${message}`,
    };

    if (process.env.NODE_ENV === 'development') {
      functions.logger.warn('开发模式：跳过真实邮件发送');
      res.status(200).json({
        success: true,
        debug: { email, message }
      });
      return;
    } else {
      await sgMail.send(msg); // 生产环境才真实发送
      functions.logger.info('邮件发送成功');
      res.status(200).json({ success: true });
      return;
    }

  } catch (error) {
    const sgError = error as { code: number, message: string, response?: { body: any } };

    functions.logger.error('完整错误信息:', {
      code: sgError.code,
      message: sgError.message,
      responseBody: sgError.response?.body
    });
    res.status(500).json({
      success: false,
      error: sgError.response?.body?.errors || '邮件发送失败'
    });
    return;
  }
});
