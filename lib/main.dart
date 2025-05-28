import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:n47_web/database/event_repository.dart';
import 'package:n47_web/home/home_bloc.dart';
import 'package:n47_web/home/home_page.dart';
import 'package:n47_web/l10n/generated/app_localizations.dart';
import 'package:n47_web/navigation/AppRouter.dart';
import 'package:n47_web/utils/logger_util.dart';
import 'package:firebase_core/firebase_core.dart';
import 'bloc/future_events_cubit.dart';
import 'bloc/history_events_cubit.dart';
import 'cookie/cookie_consent_overlay.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GestureBinding.instance.resamplingEnabled = true;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('6LeJKCcrAAAAAB5_i37B7M-maDo21Zqao9mrzZ07'),
  );

  await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(true);

  await EventRepository.init();
  runApp(const N47App());
}

class N47App extends StatelessWidget {
  const N47App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeBloc()),
        BlocProvider(create: (_) {
          final cubit = FutureEventsCubit();
          cubit.initializeFirebaseData().then((_) => cubit.loadEvents());
          return cubit;
        }),
        BlocProvider(create: (_) => HistoryEventsCubit()),
      ],
      child: MaterialApp(
        title: 'N47',
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
        ),
        onGenerateRoute: AppRouter.generateRoute,
        home: const Stack(
          children: [
            HomePage(),
            CookieConsentOverlay(),
          ],
        ),
      ),
    );
  }
}
