import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:n47_web/database/event.dart';
import '../utils/logger_util.dart';

class EventRepository {
  static const _futureEventsBox = 'future';
  static const _futureHashKeyBox = 'futureHashKey';
  static const _futureEventsHashKey = 'futureEventsHash';

  static const _historyEventsBox = 'history';
  static const _historyHashKeyBox = 'historyHashKey';
  static const _historyEventsHashKey = 'historyEventsHash';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(EventAdapter());
    await Hive.openBox<Event>(_historyEventsBox);
    await Hive.openBox<Event>(_futureEventsBox);
    await Hive.openBox(_futureHashKeyBox);
    await Hive.openBox(_historyHashKeyBox);
  }

  static Future<void> importFutureEvents(List<Map<String, dynamic>> futureEvents) async {
    final events = futureEvents.map((data) => Event.fromJson(data)).toList();
    final eventsBox = Hive.box<Event>(_futureEventsBox);
    final keyBox = Hive.box(_futureHashKeyBox);

    final newHash = _calculateListHash(events);
    final lastHash = keyBox.get(_futureEventsHashKey, defaultValue: -1);
    if (lastHash == newHash) {
      logger.d("same json, don´t import");
      return;
    }

    await eventsBox.clear();
    await eventsBox.addAll(events);
    await keyBox.put(_futureEventsHashKey, newHash);
  }

  static List<Event> getFutureEventsSortedByDate() {
    return Hive.box<Event>(_futureEventsBox)
        .values
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  static Future<void> importHistoryEvents(List<Map<String, dynamic>> historyEvents) async {
    final events = historyEvents.map((data) => Event.fromJson(data)).toList();
    final eventsBox = Hive.box<Event>(_historyEventsBox);
    final keyBox = Hive.box(_historyHashKeyBox);

    final newHash = _calculateListHash(events);
    final lastHash = keyBox.get(_historyEventsHashKey, defaultValue: -1);
    if (lastHash == newHash) {
      logger.d("same json, don´t import");
      return;
    }

    await eventsBox.clear();
    await eventsBox.addAll(events);
    await keyBox.put(_historyEventsBox, newHash);
  }

  static List<Event> getHistoryEventsSortedByDate() {
    return Hive.box<Event>(_historyEventsBox)
        .values
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

