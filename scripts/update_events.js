const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path');

let serviceAccount;

// 1. 优先尝试从环境变量读取（GitHub Actions 流程）
if (process.env.FIREBASE_SERVICE_ACCOUNT) {
  try {
    serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);
  } catch (e) {
    console.error('❌ 错误: 环境变量 FIREBASE_SERVICE_ACCOUNT JSON 解析失败:', e);
    process.exit(1);
  }
} else {
  // 2. 本地测试回退：检查本地 serviceAccountKey.json 文件路径
  const localKeyPaths = [
    path.resolve(__dirname, '../serviceAccountKey.json'),
    path.resolve(__dirname, '../functions/src/serviceAccountKey.json'),
    path.resolve(__dirname, '../functions/serviceAccountKey.json'),
  ];

  const foundPath = localKeyPaths.find((p) => fs.existsSync(p));
  if (foundPath) {
    console.log(`🔑 本地运行，读取密钥文件: ${foundPath}`);
    serviceAccount = require(foundPath);
  } else {
    console.error('❌ 错误: 未设置 FIREBASE_SERVICE_ACCOUNT 环境变量，且未找到本地 serviceAccountKey.json');
    process.exit(1);
  }
}

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

async function syncFutureEvents() {
  const futurePath = path.resolve(__dirname, '../assets/data/future.json');
  if (!fs.existsSync(futurePath)) {
    console.log('⚠️ 未找到 assets/data/future.json，跳过同步');
    return;
  }
  console.log(`📄 正在读取: ${futurePath}`);
  const items = JSON.parse(fs.readFileSync(futurePath, 'utf-8'));

  const batch = db.batch();
  items.forEach((item) => {
    const docRef = db.collection('future').doc(String(item.id));
    batch.set(docRef, item);
  });
  await batch.commit();
  console.log(`✅ [future] 已同步覆盖 ${items.length} 条数据到 Firestore Collection [future]`);
}

async function syncHistoryEvents() {
  const historyPath = path.resolve(__dirname, '../assets/data/history.json');
  if (!fs.existsSync(historyPath)) {
    console.log('⚠️ 未找到 assets/data/history.json，跳过同步');
    return;
  }
  console.log(`📄 正在读取: ${historyPath}`);
  const items = JSON.parse(fs.readFileSync(historyPath, 'utf-8'));

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

  const batch = db.batch();
  processedItems.forEach((item) => {
    const docRef = db.collection('history').doc(String(item.id));
    batch.set(docRef, item);
  });
  await batch.commit();
  console.log(`✅ [history] 已同步覆盖 ${processedItems.length} 条数据到 Firestore Collection [history]`);
}

async function main() {
  try {
    console.log('🚀 开始自动同步 JSON 数据至 Firebase Firestore...');
    await syncFutureEvents();
    await syncHistoryEvents();
    console.log('🎉 所有数据成功同步至 Firestore！');
  } catch (error) {
    console.error('❌ 同步过程中发生错误:', error);
    process.exit(1);
  }
}

main();
