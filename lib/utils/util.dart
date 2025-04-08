class Util {

  static String formatHtmlText(String rawText) {
    return rawText
        .replaceAll(r'\n', '\n')
        .replaceAll(r'\"', '"');
  }
}