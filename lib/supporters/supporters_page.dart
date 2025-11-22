import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:n47_web/supporters/supporter_item.dart';
import '../footer/app_footer.dart';
import '../header/app_header.dart';
import '../l10n/generated/app_localizations.dart';
import '../refreshable/refreshable_page.dart';
import '../utils/util.dart';

class SupportersPage extends StatelessWidget {
  SupportersPage({super.key});

  final List<Map<String, String>> supporters = [
    {'image': 'assets/supporters/nitro.jpg', 'url': 'https://nitrosnowboards.com'},
    {'image': 'assets/supporters/jones.jpg', 'url': 'https://www.jonessnowboards.com'},
    {'image': 'assets/supporters/nidecker.jpg', 'url': 'https://www.nidecker.com'},
    {'image': 'assets/supporters/yes.jpg', 'url': 'https://yessnowboards.com'},
    {'image': 'assets/supporters/elooa.jpg', 'url': 'https://elooa.com'},
    {'image': 'assets/supporters/total.jpg', 'url': 'https://www.skischuletotal.at/'},
    {'image': 'assets/supporters/goski.jpg', 'url': ''},
    {'image': 'assets/supporters/stadele.jpg', 'url': 'https://www.stadele.eu'},
    {'image': 'assets/supporters/snowland.jpg', 'url': ''},
  ];

  @override
  Widget build(BuildContext context) {
    return RefreshablePage(
      child: Stack(
        children: [
          Container(
            color: Colors.white,
          ),
          const AppHeader(),
          Positioned(
            top: Util.isMobile(context) ? 60 : 80,
            left: 0,
            right: 0,
            bottom: 0,
            child: buildContent(context),
          ),
        ],
      ),
    );
  }

  Widget buildContent(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalTextPadding = getResponsiveValue(
          context,
          desktop: 80.0,
          mobile: 20.0,
        );

        final horizontalImagePadding = getResponsiveValue(
          context,
          desktop: 160.0,
          mobile: 20.0,
        );

        final crossAxisCount = getCrossAxisCount(constraints.maxWidth);

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalTextPadding,
                  40,
                  horizontalTextPadding,
                  20,
                ),
                child: Text(
                  AppLocalizations.of(context)!.supportersTitle,
                  style: GoogleFonts.inter(
                    fontSize: getResponsiveValue(
                      context,
                      desktop: 36.0,
                      mobile: 24.0,
                    ),
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalImagePadding),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: getSpacingValue(context),
                    crossAxisSpacing: getSpacingValue(context),
                    childAspectRatio: 1,
                  ),
                  itemCount: supporters.length,
                  itemBuilder: (context, index) {
                    return SupporterItem(
                      imagePath: supporters[index]['image']!,
                      url: supporters[index]['url']!,
                      maxSize: calculateMaxItemSize(
                        context,
                        constraints.maxWidth,
                        crossAxisCount,
                        horizontalTextPadding,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 60),
              SizedBox(
                width: double.infinity,
                child: const AppFooter(),
              ),
            ],
          ),
        );
      },
    );
  }

  int getCrossAxisCount(double screenWidth) {
    if (screenWidth > 900) return 4;
    if (screenWidth > 600) return 3;
    return 2;
  }

  double getSpacingValue(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 20.0;
    return 10.0;
  }

  double calculateMaxItemSize(
      BuildContext context,
      double screenWidth,
      int crossAxisCount,
      double padding,
      ) {
    final spacing = getSpacingValue(context);
    final availableWidth = screenWidth - (padding * 2) - ((crossAxisCount - 1) * spacing);
    return availableWidth / crossAxisCount;
  }

  double getResponsiveValue(
      BuildContext context, {
        required double desktop,
        required double mobile,
      }) {
    final width = MediaQuery.of(context).size.width;
    if (width > 900) return desktop;
    return mobile;
  }
}