import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../utils/Logger.dart';

class EventStorage {


  Future<List<Map<String, dynamic>>> fetchEvents() async {
    try {
      final firestore = FirebaseFirestore.instanceFor(
          app: Firebase.app(),
          databaseId: 'n47events'
      );

      final querySnapshot = await firestore
          .collection('history')
          .get();

      return querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,      // 文档ID
          ...doc.data(),    // 文档字段（title, date等）
        };
      }).toList();
    } catch (e) {
      Logger.e('获取数据失败: $e');
      return [];
    }
  }

}