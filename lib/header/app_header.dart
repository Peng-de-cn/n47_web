import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:n47_web/l10n/generated/app_localizations.dart';
import 'package:n47_web/navigation/navi_item.dart';

import '../home/home_page.dart';
import '../navigation/AppRouter.dart';
import '../utils/logger_util.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.03,
          vertical: 10,
        ),
        color: Colors.transparent,
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              return buildMobileLayout(context, constraints);
            } else {
              return buildDesktopLayout(context, constraints);
            }
          },
        ),
      ),
    );
  }

  Widget buildMobileLayout(BuildContext context, BoxConstraints constraints) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildLogo(context, 48),

          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 4),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildNavItem(context, AppLocalizations.of(context)!.naviHistory, '/history'),
                    _buildNavItem(context, AppLocalizations.of(context)!.naviSponsors, '/sponsors'),
                    _buildNavItem(context, AppLocalizations.of(context)!.naviContact, '/contact'),
                    _buildNavItem(context, AppLocalizations.of(context)!.naviAbout, '/about'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDesktopLayout(BuildContext context, BoxConstraints constraints) {
    final bool isLargeScreen = constraints.maxWidth > 900;
    if (isLargeScreen) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: _buildLogo(context, 80),
          ),
          Positioned(
            right: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildNavItem(context, AppLocalizations.of(context)!.naviHistory, '/history'),
                const SizedBox(width: 20),
                _buildNavItem(context, AppLocalizations.of(context)!.naviSponsors, '/sponsors'),
                const SizedBox(width: 20),
                _buildNavItem(context, AppLocalizations.of(context)!.naviContact, '/contact'),
                const SizedBox(width: 20),
                _buildNavItem(context, AppLocalizations.of(context)!.naviAbout, '/about'),
              ],
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildLogo(context, 80),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildNavItem(context, AppLocalizations.of(context)!.naviHistory, '/history'),
              const SizedBox(width: 20),
              _buildNavItem(context, AppLocalizations.of(context)!.naviSponsors, '/sponsors'),
              const SizedBox(width: 20),
              _buildNavItem(context, AppLocalizations.of(context)!.naviContact, '/contact'),
              const SizedBox(width: 20),
              _buildNavItem(context, AppLocalizations.of(context)!.naviAbout, '/about'),
            ],
          ),
        ],
      );
    }

  }

  Widget _buildLogo(BuildContext context, double size) {
    return InkWell(
      onTap: () {
        final currentRoute = ModalRoute.of(context)?.settings.name ?? '/';
        if (currentRoute != '/') {
          Navigator.pushReplacement(
            context,
            AppRouter.createFadeRoute(
              const HomePage(),
              const RouteSettings(name: '/'),
            ),
          );
        }
      },
      child: Image.asset(
        'assets/icons/n47_logo.png',
        width: size,
        height: size,
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String titleKey, String routeName) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: NavItem(
        title: titleKey,
        routeName: routeName,
        onTap: () => Navigator.pushNamed(context, routeName),
        compact: true,
      ),
    );
  }
}