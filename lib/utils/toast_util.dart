import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

enum ToastType { success, error, warning, info }
enum ToastPosition { top, center, bottom }

class ToastUtil {
  static const Duration shortDuration = Duration(seconds: 2);
  static const Duration longDuration = Duration(seconds: 4);

  static void show({
    required BuildContext context,
    required String message,
    ToastType type = ToastType.info,
    ToastPosition position = ToastPosition.center,
    Duration? duration,
  }) {
    final color = _getColorByType(type);
    final gravity = _getGravityByPosition(position);

    if (!kIsWeb) {
      Fluttertoast.cancel();
    }
    int timeInSecForIosWeb = 2;
    if (duration != null && duration == longDuration) {
      timeInSecForIosWeb = 4;
    }

    Fluttertoast.showToast(
      msg: message,
      toastLength: _getDuration(duration, type),
      gravity: gravity,
      backgroundColor: color.withOpacity(0.9),
      textColor: Colors.white,
      fontSize: 14.0,
      webPosition: "center",
      webBgColor: color.toHex(),
      timeInSecForIosWeb: timeInSecForIosWeb
    );
  }

  static Color _getColorByType(ToastType type) {
    switch (type) {
      case ToastType.success:
        return Colors.green;
      case ToastType.error:
        return Colors.red;
      case ToastType.warning:
        return Colors.orange;
      case ToastType.info:
        return Colors.blue;
    }
  }

  static ToastGravity _getGravityByPosition(ToastPosition position) {
    switch (position) {
      case ToastPosition.top:
        return ToastGravity.TOP;
      case ToastPosition.center:
        return ToastGravity.CENTER;
      case ToastPosition.bottom:
        return ToastGravity.BOTTOM;
    }
  }

  static Toast _getDuration(Duration? duration, ToastType type) {
    if (duration != null) {
      return duration.inSeconds <= 2 ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG;
    }
    return type == ToastType.error ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT;
  }
}

extension _ColorExtensions on Color {
  String toHex() => '#${value.toRadixString(16).padLeft(8, '0').substring(2)}';
}
