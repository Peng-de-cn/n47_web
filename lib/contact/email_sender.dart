import 'package:http/http.dart' as http;
import 'dart:convert';

class EmailSender {
  static Future<void> submitForm(String email, String message) async {
    // 替换为你的 Firebase 函数 URL
    final url = 'https://us-central1-n47web.cloudfunctions.net/sendemail';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'message': message,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true) {
          print('邮件发送成功');
        } else {
          print('邮件发送失败：${jsonResponse['error']}');
        }
      } else {
        print('HTTP 请求失败：${response.statusCode}');
      }
    } catch (e) {
      print('发送邮件时发生错误：$e');
    }
  }
}