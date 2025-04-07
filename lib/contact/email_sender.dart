import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:n47_web/utils/Logger.dart';

class EmailSender {
  static Future<void> submitForm(String name, String email, String subject, String message) async {
    // Firebase URL
    final url = 'https://us-central1-n47web.cloudfunctions.net/sendemail';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
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
          Logger.d("send email success");
        } else {
          Logger.e("send email failed：${jsonResponse['error']}");
        }
      } else {
        Logger.e("http request failed：${response.statusCode}");
      }
    } catch (e) {
      Logger.e("sending email failed：$e");
    }
  }
}