import 'package:flutter/material.dart';
import 'package:n47_web/about/about_page.dart';
import 'package:n47_web/history/history_page.dart';

import '../contact/contact_page.dart';
import '../home/home_page.dart';
import '../sponsors/sponsors_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return createFadeRoute(HomePage(), settings);
      case '/history':
        return createFadeRoute(HistoryPage(), settings);
      case '/sponsors':
        return createFadeRoute(SponsorsPage(), settings);
      case '/contact':
        return createFadeRoute(ContactPage(), settings);
      case '/about':
        return createFadeRoute(AboutPage(), settings);
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

  static Route<dynamic> createFadeRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeIn,
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
