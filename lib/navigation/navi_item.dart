import 'package:flutter/material.dart';

// 导航栏项组件
class NavItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const NavItem({Key? key, required this.title, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}