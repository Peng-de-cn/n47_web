import 'package:flutter/cupertino.dart';

class Util {

  static String formatHtmlText(String rawText) {
    return rawText
        .replaceAll(r'\n', '\n')
        .replaceAll(r'\"', '"');
  }

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }
}