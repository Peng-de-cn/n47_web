import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage('assets/icons/n47_logo.png'), context);
    return Center(child: CircularProgressIndicator());
  }
}