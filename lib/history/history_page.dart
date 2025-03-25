import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:n47_web/header/app_header.dart';
import '../bloc/events_cubit.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final events = context.read<EventsCubit>().state;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.white,
          ),
          const AppHeader(),
          // Positioned(
          //   top: 100, // 在Header下方
          //   left: 0,
          //   right: 0,
          //   bottom: 0,
          //   child: _buildHistoryContent(),
          // ),
        ],
      )
    );
  }


}