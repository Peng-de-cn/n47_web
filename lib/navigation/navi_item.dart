import 'package:flutter/material.dart';

import '../utils/logger_util.dart';

class NavItem extends StatelessWidget {
  final String title;
  final String routeName;
  final VoidCallback onTap;
  final bool compact;

  const NavItem({
    super.key,
    required this.title,
    required this.routeName,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '/';
    final isActive = currentRoute == routeName;

    return InkWell(
      onTap: () {
        if (!isActive) {
          onTap();
        } else {
          logger.d('Already on $routeName page, ignoring click');
        }
      },
      child: Padding(
        padding: compact
            ? const EdgeInsets.symmetric(horizontal: 6, vertical: 4)
            : const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          title,
          style: TextStyle(color: isActive ? Colors.grey : Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
