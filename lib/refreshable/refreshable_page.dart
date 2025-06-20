import 'dart:html' as html;
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
            html.window.location.reload();
          }
        },
        child: child,
      ),
    );
  }
}
