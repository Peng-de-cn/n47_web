import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:n47_web/database/event.dart';

import '../utils/Logger.dart';

class EventDatabase {
  static const _eventsBox = 'events';
  static const _keyBox = 'hashKey';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(EventAdapter());
    await Hive.openBox<Event>(_eventsBox);
    await Hive.openBox(_keyBox);
  }

  static Future<void> importEvents(List<Event> events) async {
    final eventsBox = Hive.box<Event>(_eventsBox);
    final keyBox = Hive.box(_keyBox);

    final newHash = _calculateListHash(events);
    final lastHash = keyBox.get('eventsHash', defaultValue: -1);

    if (lastHash == newHash) {
      Logger.d("same json, don´t import");
      return;
    }

    await eventsBox.clear();
    await eventsBox.addAll(events);
    await keyBox.put('eventsHash', newHash);
  }

  static List<Event> getEvents() {
    return Hive.box<Event>(_eventsBox).values.toList();
  }

  static List<Event> getHistoryEventsSortedByDate() {
    return Hive.box<Event>(_eventsBox)
        .values
        .where((event) => event.isHistory)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  static List<Event> getCurrentEventsSortedByDate() {
    return Hive.box<Event>(_eventsBox)
        .values
        .where((event) => !event.isHistory)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }
}

int _calculateListHash(List<Event> events) {
  return events.fold(0, (hash, event) {
    final eventJson = event.toJson();
    return hash ^ jsonEncode(eventJson).hashCode;
  });
}

