import 'package:flutter/material.dart';

import '../utils/Logger.dart';

class NavItem extends StatelessWidget {
  final String title;
  final String routeName;
  final VoidCallback onTap;

  const NavItem({super.key, required this.title, required this.routeName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '/';
    final isActive = currentRoute == routeName;

    return InkWell(
      onTap: () {
        if (!isActive) {
          onTap();
        } else {
          Logger.d('Already on $routeName page, ignoring click');
        }
      },
      child: Text(
        title,
        style: TextStyle(
          color: isActive ? Colors.grey : Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}
