import 'package:flutter/material.dart';
import 'package:n47_web/contact/email_sender.dart';
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
              child: buildContent(context),
            ),
          ],
        )
    );
  }

  Widget buildContent(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: constraints.maxWidth > 600 ? 80 : 40,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () async {
                    await EmailSender.submitForm("test@gmail.com", "12345");
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    backgroundColor: Colors.black, // Button color
                    foregroundColor: Colors.white, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Submit Form',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                SizedBox(
                  width: double.infinity,
                  child: const AppFooter(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}