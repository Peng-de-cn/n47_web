import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:n47_web/header/app_header.dart';
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
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(state.backgroundImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Header
              const AppHeader(),
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
