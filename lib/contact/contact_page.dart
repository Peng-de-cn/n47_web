import 'package:flutter/material.dart';
import 'package:n47_web/header/app_header.dart';

import '../footer/app_footer.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Container(
              color: Colors.white,
            ),
            const AppHeader(),
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              bottom: 0,
              child: AppFooter(),
            ),
          ],
        )
    );
  }

}