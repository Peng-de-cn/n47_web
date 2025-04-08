import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:n47_web/database/event_repository.dart';
import 'package:n47_web/home/home_bloc.dart';
import 'package:n47_web/home/home_page.dart';
import 'package:n47_web/l10n/generated/app_localizations.dart';
import 'package:n47_web/navigation/AppRouter.dart';
import 'package:n47_web/splash/splash_page.dart';

import 'bloc/events_cubit.dart';
import 'database/event.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase/fire_store.dart';
import 'firebase_options.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//
//   EventStorage eventStorage = EventStorage();
//   final testEvent = await eventStorage.fetchEvents();
//   for (var event in testEvent) {
//     Logger.d('test: ${event.keys}: ${event.values}');
//   }
//
//   await EventDatabase.init();
//
//   final jsonData = await rootBundle.loadString('assets/data/data.json');
//   final events = (jsonDecode(jsonData) as List).map((e) => Event.fromJson(e)).toList();
//   await EventDatabase.importEvents(events);
//
//   final historyEvents = EventDatabase.getHistoryEventsSortedByDate();
//
//   runApp(
//     MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (_) => HomeBloc()),
//         BlocProvider(create: (_) => EventsCubit()..loadEvents(historyEvents)),
//       ],
//       child: const N47App(),
//     ),
//   );
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const N47App());
}

class N47App extends StatelessWidget {
  const N47App({Key? key}) : super(key: key);

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
    await EventRepository.init();

    List<Map<String, dynamic>> historyEvents = await Firestore.fetchHistoryEvents();
    await EventRepository.importHistoryEvents(historyEvents);
  }

  Widget buildAppContent() {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeBloc()),
        BlocProvider(create: (_) => EventsCubit()),
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
          home: BlocProvider(create: (context) => HomeBloc(), child: HomePage())
      )
    );
  }

}
