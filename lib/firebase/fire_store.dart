import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../utils/logger_util.dart';

class Firestore {

  static Future<List<Map<String, dynamic>>> fetchFutureEvents() async {
    try {
      final firestore = FirebaseFirestore.instance;

      final querySnapshot = await firestore
          .collection('future')
          .get();

      return querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data(),
        };
      }).toList();
    } catch (e) {
      logger.e('load firestore error: $e');
      try {
        final jsonData = await rootBundle.loadString('assets/data/future.json');
        final List<dynamic> decodedData = jsonDecode(jsonData);
        return decodedData
            .map((item) => item as Map<String, dynamic>)
            .toList();
      } catch (e) {
        logger.e('load local data error: $e');
        return [];
      }
    }
  }

  static Future<List<Map<String, dynamic>>> fetchHistoryEvents() async {
    try {
      final firestore = FirebaseFirestore.instance;

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
      logger.e('load firestore error: $e');
      try {
        final jsonData = await rootBundle.loadString('assets/data/history.json');
        final List<dynamic> decodedData = jsonDecode(jsonData);
        return decodedData
            .map((item) => item as Map<String, dynamic>)
            .toList();
      } catch (e) {
        logger.e('load local data error: $e');
        return [];
      }
    }
  }

  static Future<String?> loadImageUrl(String imagePath) async {
    try {
      if (imagePath.startsWith("assets")) {
        return imagePath;
      } else {
        final ref = FirebaseStorage.instance.ref(imagePath);
        final url = await ref.getDownloadURL();
        logger.d('Successfully loaded image URL: $url');
        return url;
      }
    } catch (e, stackTrace) {
      logger.e('Failed to load image: $e, error:$e, stackTrace: $stackTrace');
      return null;
    }
  }

}