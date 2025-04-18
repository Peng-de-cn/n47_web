import 'package:flutter/material.dart';
import 'package:n47_web/l10n/generated/app_localizations.dart';
import 'package:n47_web/navigation/navi_item.dart';

import '../home/home_page.dart';
import '../navigation/AppRouter.dart';
import '../utils/logger_util.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      left: 10,
      right: 60,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                final currentRoute = ModalRoute.of(context)?.settings.name ?? '/';
                if (currentRoute != '/') {
                  Navigator.pushReplacement(
                    context,
                    AppRouter.createFadeRoute(HomePage(), RouteSettings(name: '/')),
                  );
                } else {
                  logger.d('Already on home page, ignoring click');
                }
              },
              child: Image.asset('assets/icons/n47_logo.png', width: 60, height: 60),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                NavItem(
                  title: AppLocalizations.of(context)!.naviHistory,
                  routeName: '/history',
                  onTap: () {
                    Navigator.pushNamed(context, '/history');
                  },
                ),
                SizedBox(width: 20),
                NavItem(
                  title: AppLocalizations.of(context)!.naviSponsors,
                  routeName: '/sponsors',
                  onTap: () {
                    Navigator.pushNamed(context, '/sponsors');
                  },
                ),
                SizedBox(width: 20),
                NavItem(
                  title: AppLocalizations.of(context)!.naviContact,
                  routeName: '/contact',
                  onTap: () {
                    Navigator.pushNamed(context, '/contact');
                  },
                ),
                SizedBox(width: 20),
                NavItem(
                  title: AppLocalizations.of(context)!.naviAbout,
                  routeName: '/about',
                  onTap: () {
                    Navigator.pushNamed(context, '/about');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}