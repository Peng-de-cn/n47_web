class Logger {
  static const String tagDef = "N47";

  static bool debuggable = true;
  static String _tag = tagDef;

  static void init({bool isDebug = false, String tag = tagDef}) {
    debuggable = isDebug;
    _tag = tag;
  }

  static void e(Object object, {String tag = ""}) {
    _printLog(tag, object);
  }

  static void d(Object object, {String tag = ""}) {
    if (debuggable) {
      _printLog(tag, object);
    }
  }

  static void _printLog(String tag, Object object) {
    StringBuffer sb = StringBuffer();
    sb.write((tag.isEmpty) ? _tag : tag);
    sb.write(": ");
    sb.write(object);
    print(sb.toString());
  }
}
