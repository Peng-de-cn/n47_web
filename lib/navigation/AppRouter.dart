import 'package:flutter/material.dart';
import 'package:n47_web/about/about_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/about':
        return MaterialPageRoute(builder: (_) => AboutPage());
      // case '/services':
      //   return MaterialPageRoute(builder: (_) => ServicesPage());
      // case '/contact':
      //   return MaterialPageRoute(builder: (_) => ContactPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}