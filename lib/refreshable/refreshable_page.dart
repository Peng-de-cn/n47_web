import 'dart:html' as html;
import 'package:flutter/material.dart';

class RefreshablePage extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;

  const RefreshablePage({
    super.key,
    required this.child,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: RefreshIndicator(
        onRefresh: () async {
          html.window.location.reload();
        },
        child: child,
      ),
    );
  }
}
