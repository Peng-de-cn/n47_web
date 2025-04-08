import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/logger_util.dart';


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
          logger.d("send email success");
        } else {
          logger.e("send email failed：${jsonResponse['error']}");
        }
      } else {
        logger.e("http request failed：${response.statusCode}");
      }
    } catch (e) {
      logger.e("sending email failed：$e");
    }
  }
}