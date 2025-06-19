import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'dart:html' as html;

class Util {

  static String formatHtmlText(String rawText) {
    return rawText
        .replaceAll(r'\n', '\n')
        .replaceAll(r'\"', '"');
  }

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isSafariBrowser() {
    if (!kIsWeb) return false;
    final userAgent = html.window.navigator.userAgent.toLowerCase();
    return userAgent.contains('safari') &&
        !userAgent.contains('chrome') &&
        !userAgent.contains('chromium');
  }
}