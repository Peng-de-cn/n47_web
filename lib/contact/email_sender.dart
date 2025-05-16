import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../l10n/generated/app_localizations.dart';
import '../utils/logger_util.dart';


class EmailSender {
  static Future<({bool success, int httpStatusCode, String? message})> submitForm(String name, String email, String subject, String message) async {
    // Firebase URL
    final url = 'https://us-central1-n47web.cloudfunctions.net/sendemail';

    try {
      final appCheckToken = await FirebaseAppCheck.instance.getToken();
      logger.d("appCheckToken: $appCheckToken");
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json',
          'X-Firebase-AppCheck': appCheckToken ?? ''},
        body: jsonEncode({
          'name': name,
          'email': email,
          'subject': subject,
          'message': message,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true) {
          logger.d("send email success");
          return (success: true, httpStatusCode: response.statusCode, message: null);
        } else {
          final error = jsonResponse['error'] ?? 'Unknown error';
          logger.e("send email failed：${jsonResponse['error']}");
          return (success: false, httpStatusCode: response.statusCode, message: error.toString());
        }
      } else {
        logger.e("http request failed：${response.statusCode}");
        return (success: false, httpStatusCode: response.statusCode, message: response.statusCode.toString());
      }
    } catch (e) {
      logger.e("sending email failed：$e");
      return (success: false, httpStatusCode: -1, message: e.toString());
    }
  }
}