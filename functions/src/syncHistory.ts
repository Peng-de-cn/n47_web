import * as admin from 'firebase-admin';
import * as fs from 'fs';
import * as path from 'path';

// 1. 明确指定 serviceAccountKey.json 文件的真实绝对路径
// 如果 serviceAccountKey.json 放在 functions 根目录下：
const serviceAccountPath = path.resolve(__dirname, '../src/serviceAccountKey.json');

// 如果你把 serviceAccountKey.json 放在 functions/src 目录下，解除下面这行的注释：
// const serviceAccountPath = path.resolve(__dirname, './serviceAccountKey.json');

if (!fs.existsSync(serviceAccountPath)) {
  console.error(`❌ 找不到密钥文件，请确认 serviceAccountKey.json 存放的位置: ${serviceAccountPath}`);
  process.exit(1);
}

const serviceAccount = require(serviceAccountPath);

// 初始化 Firebase Admin 并传入 credential 凭据
if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    // 如果 serviceAccountKey.json 里包含 project_id，会自动读取；
    // 如果依然报错，可以手动加上 projectId 字段（取消下一行的注释并填入你的 Firebase Project ID）：
    // projectId: 'your-firebase-project-id'
  });
}

const db = admin.firestore();

interface HistoryItem {
  id: string;
  title: string;
  date: string;
  dateText: string;
  description: string;
  imageWeb: string;
  imageMobile: string;
  [key: string]: any;
}

async function syncHistoryData() {
  try {
    // 相对路径：functions/src/ -> ../../assets/data/history.json
    const jsonPath = path.resolve(__dirname, '../../assets/data/history.json');

    if (!fs.existsSync(jsonPath)) {
      throw new Error(`找不到 JSON 文件，请检查路径: ${jsonPath}`);
    }

    console.log(`📄 正在读取 JSON 文件: ${jsonPath}`);
    const rawData = fs.readFileSync(jsonPath, 'utf-8');
    const items: HistoryItem[] = JSON.parse(rawData);

    console.log(`🔍 共读取到 ${items.length} 条数据，开始转换路径...`);

    // 转换路径并处理数据
    const processedItems = items.map((item) => {
      const newItem = { ...item };

      if (newItem.imageWeb) {
        newItem.imageWeb = newItem.imageWeb.replace(
          /^assets\/images\/history\/web\//,
          'history_web/'
        );
      }

      if (newItem.imageMobile) {
        newItem.imageMobile = newItem.imageMobile.replace(
          /^assets\/images\/history\/mobile\//,
          'history_mobile/'
        );
      }

      return newItem;
    });

    // 开始同步到 Firestore（目标集合：history）
    const collectionName = 'history';
    console.log(`🚀 开始同步覆盖到 Firestore 集合 [${collectionName}]...`);

    const batchSize = 500;
    for (let i = 0; i < processedItems.length; i += batchSize) {
      const chunk = processedItems.slice(i, i + batchSize);
      const batch = db.batch();

      chunk.forEach((item) => {
        // 使用 JSON 中的 id 作为 Document ID
        const docRef = db.collection(collectionName).doc(String(item.id));
        // set() 方法会直接覆盖原 Document 内容
        batch.set(docRef, item);
      });

      await batch.commit();
      console.log(`✅ 已完成 ${Math.min(i + batchSize, processedItems.length)} / ${processedItems.length} 条数据同步`);
    }

    console.log(`🎉 集合 [${collectionName}] 数据同步并覆盖成功！`);
  } catch (error) {
    console.error(`❌ 同步失败:`, error);
  }
}

// 执行同步
syncHistoryData();