import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../footer/app_footer.dart';
import '../header/app_header.dart';
import '../l10n/generated/app_localizations.dart';
import '../refreshable/refreshable_page.dart';
import '../utils/util.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

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
    // String? appCheckToken;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: constraints.maxWidth > 600 ? 80 : 40,
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

                    // // ✅ 添加一个按钮和 TextField 显示 token
                    // StatefulBuilder(
                    //   builder: (context, setState) {
                    //     return Column(
                    //       children: [
                    //         ElevatedButton(
                    //           onPressed: () async {
                    //             try {
                    //               final token = await FirebaseAppCheck.instance.getToken(true);
                    //               setState(() {
                    //                 appCheckToken = token;
                    //               });
                    //             } catch (e) {
                    //               setState(() {
                    //                 appCheckToken = '获取失败: $e';
                    //               });
                    //             }
                    //           },
                    //           child: const Text("显示 App Check Token"),
                    //         ),
                    //         const SizedBox(height: 10),
                    //         Container(
                    //           padding: const EdgeInsets.all(12),
                    //           decoration: BoxDecoration(
                    //             border: Border.all(color: Colors.grey),
                    //             borderRadius: BorderRadius.circular(4),
                    //           ),
                    //           width: double.infinity,
                    //           child: Text(
                    //             appCheckToken ?? '点击按钮获取 token',
                    //             style: const TextStyle(fontSize: 12),
                    //           ),
                    //         ),
                    //       ],
                    //     );
                    //   },
                    // ),
                  ],
                ),
              ),
              const AppFooter(),
            ],
          ),
        );
      },
    );
  }
}

