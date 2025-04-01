import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../utils/Logger.dart';

class Firestore {

  static Future<List<Map<String, dynamic>>> fetchHistoryEvents() async {
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
          'id': doc.id,
          ...doc.data(),
        };
      }).toList();
    } catch (e) {
      Logger.e('load firestore error: $e');
      try {
        final jsonData = await rootBundle.loadString('assets/data/data.json');
        final List<dynamic> decodedData = jsonDecode(jsonData);

        return decodedData
            .map((item) => item as Map<String, dynamic>)
            .toList();
      } catch (e) {
        Logger.e('load local data error: $e');
        return [];
      }
    }
  }

  static Future<String?> loadImageUrl(String imagePath) async {
    try {
      final ref = FirebaseStorage.instanceFor().ref().child(imagePath);
      final url = await ref.getDownloadURL();
      Logger.d('Successfully loaded image URL: $url');
      return url;
    } catch (e, stackTrace) {
      Logger.e('Failed to load image: $e, error:$e, stackTrace: $stackTrace');
      return null;
    }
  }

}