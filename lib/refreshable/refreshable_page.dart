import 'package:web/web.dart' as web;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RefreshablePage extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final Future<void> Function()? onRefresh;

  const RefreshablePage({
    super.key,
    required this.child,
    this.backgroundColor = Colors.white,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: RefreshIndicator(
        onRefresh: onRefresh ?? () async {
          if (kIsWeb) {
            web.window.location.reload();
          }
        },
        child: child,
      ),
    );
  }
}
