import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:n47_web/home/home_bloc.dart';
import '../footer/app_footer.dart';
import '../l10n/generated/app_localizations.dart';
import '../navigation/navi_item.dart';
import '../utils/Logger.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Stack(
            children: [
              // 背景图
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(state.backgroundImage), // 替换为你的背景图 URL
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Header
              Positioned(
                top: 10,
                left: 10,
                right: 60,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  color: Colors.transparent, // 透明背景
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 左上角的 Home 按钮
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/');
                          // 点击 Home 按钮的逻辑
                          Logger.d('Home clicked');
                        },
                        child: Image.asset('asset/icons/n47_logo.png', width: 60, height: 60),
                      ),
                      // 右侧导航栏
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          NavItem(
                            title: AppLocalizations.of(context)!.naviHistory,
                            onTap: () {
                              Logger.d('History clicked');
                              Navigator.pushNamed(context, '/history');
                            },
                          ),
                          SizedBox(width: 20),
                          NavItem(
                            title: AppLocalizations.of(context)!.naviSponsors,
                            onTap: () {
                              Logger.d('Sponsors clicked');
                              Navigator.pushNamed(context, '/sponsors');
                            },
                          ),
                          SizedBox(width: 20),
                          NavItem(
                            title: AppLocalizations.of(context)!.naviContact,
                            onTap: () {
                              Logger.d('Contact clicked');
                              Navigator.pushNamed(context, '/contact');
                            },
                          ),
                          SizedBox(width: 20),
                          NavItem(
                            title: AppLocalizations.of(context)!.naviAbout,
                            onTap: () {
                              Logger.d('About clicked');
                              Navigator.pushNamed(context, '/about');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Title
              Positioned(
                  top: 200,
                  left: 100,
                  right: 100,
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.appTitle,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.rajdhani(
                        fontSize: 64,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 1.5,
                        shadows: [
                          Shadow(
                            color: Color.fromRGBO(0, 0, 0, 0.3),
                            blurRadius: 4,
                            offset: Offset(2, 2)
                          )
                        ]
                      ),
                    ),
                  )
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: const AppFooter(),
              ),
            ],
          );
        },
      ),
    );
  }
}
