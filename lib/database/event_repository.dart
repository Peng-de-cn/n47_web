import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:n47_web/database/event.dart';
import '../utils/logger_util.dart';

class EventRepository {
  static const _eventsBox = 'events';
  static const _historyEventsBox = 'history';
  static const _keyBox = 'hashKey';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(EventAdapter());
    await Hive.openBox<Event>(_historyEventsBox);
    await Hive.openBox(_keyBox);
  }

  static Future<void> importHistoryEvents(List<Map<String, dynamic>> historyEvents) async {
    final events = historyEvents.map((data) => Event.fromJson(data)).toList();

    final eventsBox = Hive.box<Event>(_historyEventsBox);
    final keyBox = Hive.box(_keyBox);

    final newHash = _calculateListHash(events);
    final lastHash = keyBox.get('eventsHash', defaultValue: -1);
    logger.d("test");
    if (lastHash == newHash) {
      logger.d("same json, don´t import");
      return;
    }

    await eventsBox.clear();
    await eventsBox.addAll(events);
    await keyBox.put('eventsHash', newHash);
  }

  static List<Event> getEvents() {
    return Hive.box<Event>(_historyEventsBox).values.toList();
  }

  static List<Event> getHistoryEventsSortedByDate() {
    return Hive.box<Event>(_historyEventsBox)
        .values
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // static List<Event> getCurrentEventsSortedByDate() {
  //   return Hive.box<Event>(_eventsBox)
  //       .values
  //       .toList()
  //     ..sort((a, b) => b.date.compareTo(a.date));
  // }
}

int _calculateListHash(List<Event> events) {
  return events.fold(0, (hash, event) {
    final eventJson = event.toJson();
    return hash ^ jsonEncode(eventJson).hashCode;
  });
}

