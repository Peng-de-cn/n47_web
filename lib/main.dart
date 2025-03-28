import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:n47_web/home/home_bloc.dart';
import 'package:n47_web/home/home_page.dart';
import 'package:n47_web/l10n/generated/app_localizations.dart';
import 'package:n47_web/navigation/AppRouter.dart';
import 'package:n47_web/utils/Logger.dart';

import 'bloc/events_cubit.dart';
import 'database/event.dart';
import 'database/event_database.dart';

void main() async {
  await EventDatabase.init();

  final jsonData = await rootBundle.loadString('assets/data/data.json');
  final events = (jsonDecode(jsonData) as List).map((e) => Event.fromJson(e)).toList();
  await EventDatabase.importEvents(events);

  final historyEvents = EventDatabase.getHistoryEventsSortedByDate();
  for (var event in historyEvents) {
    Logger.d('${event.date} - ${event.title}');
  }

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeBloc()),
        BlocProvider(create: (_) => EventsCubit()..loadEvents(historyEvents)),
      ],
      child: const N47App(),
    ),
  );
}

class N47App extends StatelessWidget {
  const N47App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'N47',
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: const [Locale('en')],
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        onGenerateRoute: AppRouter.generateRoute,
        home: BlocProvider(create: (context) => HomeBloc(), child: HomePage()));
  }
}
