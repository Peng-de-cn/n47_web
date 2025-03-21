import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:n47_web/home/home_bloc.dart';
import 'package:n47_web/home/home_page.dart';
import 'package:n47_web/navigation/AppRouter.dart';

void main() {
  runApp(const N47App());
}

class N47App extends StatelessWidget {
  const N47App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'N47',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        onGenerateRoute: AppRouter.generateRoute,
        home: BlocProvider(create: (context) => HomeBloc(), child: HomePage()));
  }
}
