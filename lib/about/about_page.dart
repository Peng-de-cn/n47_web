import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../footer/app_footer.dart';
import '../header/app_header.dart';
import '../l10n/generated/app_localizations.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

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
                Text(
                  AppLocalizations.of(context)!.aboutTitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: constraints.maxWidth > 600 ? 50 : 36,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  AppLocalizations.of(context)!.aboutDetail,
                  style: GoogleFonts.inter(
                    fontSize: constraints.maxWidth > 600 ? 24 : 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    height: 1.6,
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