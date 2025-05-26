import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:n47_web/database/event_repository.dart';
import 'package:n47_web/home/home_bloc.dart';
import 'package:n47_web/home/home_page.dart';
import 'package:n47_web/l10n/generated/app_localizations.dart';
import 'package:n47_web/navigation/AppRouter.dart';
import 'package:n47_web/splash/splash_page.dart';
import 'package:n47_web/utils/logger_util.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tuple/tuple.dart';
import 'bloc/future_events_cubit.dart';
import 'bloc/history_events_cubit.dart';
import 'cookie/cookie_consent_overlay.dart';
import 'firebase/fire_store.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GestureBinding.instance.resamplingEnabled = true;
  runApp(const N47App());
}

class N47App extends StatelessWidget {
  const N47App({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeFirebase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return buildAppContent();
        }
        return SplashPage();
      },
    );
  }

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await Future.wait([
      activateAppCheck(),
      loadEvents(),
    ]);
  }

  Future<void> activateAppCheck() async {
    await FirebaseAppCheck.instance.activate(
      webProvider: ReCaptchaV3Provider('6LeJKCcrAAAAAB5_i37B7M-maDo21Zqao9mrzZ07'),
    );

    await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(true);

    // final token = await FirebaseAppCheck.instance.getToken();
    // logger.d('App Check Token: $token');
  }

  Future<void> loadEvents() async {
    final Tuple2<List<Map<String, dynamic>>, List<Map<String, dynamic>>> results =
    await Future.wait([
      Firestore.fetchFutureEvents(),
      Firestore.fetchHistoryEvents(),
    ]).then((list) => Tuple2(list[0], list[1]));

    await EventRepository.importFutureEvents(results.item1);
    await EventRepository.importHistoryEvents(results.item2);
  }

  Widget buildAppContent() {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => HomeBloc()),
          BlocProvider(create: (_) => FutureEventsCubit()),
          BlocProvider(create: (_) => HistoryEventsCubit()),
        ],
        child: MaterialApp(
            title: 'N47',
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate
            ],
            supportedLocales: const [Locale('en')],
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
            ),
            onGenerateRoute: AppRouter.generateRoute,
            home: BlocProvider(
                create: (context) => HomeBloc(),
                child: Stack(
                  children: const [
                    HomePage(),
                    CookieConsentOverlay(),
                  ],
                ),
            ),
        ),
    );
  }
}
