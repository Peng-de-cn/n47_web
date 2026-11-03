import 'dart:convert';

import 'package:hive_ce_flutter/hive_ce_flutter.dart';
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

    // 1. 注册 Hive CE 生成的 FutureEventHiveAdapter 和 HistoryEventHiveAdapter
    Hive.registerAdapter(FutureEventHiveAdapter());
    Hive.registerAdapter(HistoryEventHiveAdapter());

    // 2. 打开指定强类型的 Box
    await Hive.openBox<HistoryEventHive>(_historyEventsBox);
    await Hive.openBox<FutureEventHive>(_futureEventsBox);
    await Hive.openBox(_futureHashKeyBox);
    await Hive.openBox(_historyHashKeyBox);
  }

  static Future<void> importFutureEvents(List<Map<String, dynamic>> futureEvents) async {
    final events = futureEvents
        .map((data) => FutureEventDto.fromJson(data).toHive())
        .toList();

    final eventsBox = Hive.box<FutureEventHive>(_futureEventsBox);
    final keyBox = Hive.box(_futureHashKeyBox);

    final newHash = _calculateFutureListHash(events);
    final lastHash = keyBox.get(_futureEventsHashKey, defaultValue: -1);

    bool boxValid = true;
    try {
      for (final dynamic val in eventsBox.values.cast<dynamic>()) {
        if (val is! FutureEventHive) {
          boxValid = false;
          break;
        }
      }
    } catch (_) {
      boxValid = false;
    }

    if (lastHash == newHash && boxValid && eventsBox.isNotEmpty) {
      logger.d("same json, don´t import future");
      return;
    }

    await eventsBox.clear();
    await eventsBox.addAll(events);
    await keyBox.put(_futureEventsHashKey, newHash);
  }

  static List<FutureEventHive> getFutureEventsSortedByDate() {
    try {
      final eventsBox = Hive.box<FutureEventHive>(_futureEventsBox);
      return eventsBox.values.toList()
        ..sort((a, b) => a.date.compareTo(b.date));
    } catch (e) {
      logger.e('Failed to read future events from Hive: $e');
      return [];
    }
  }

  static Future<void> importHistoryEvents(List<Map<String, dynamic>> historyEvents) async {
    final events = historyEvents
        .map((data) => HistoryEventDto.fromJson(data).toHive())
        .toList();

    final eventsBox = Hive.box<HistoryEventHive>(_historyEventsBox);
    final keyBox = Hive.box(_historyHashKeyBox);

    final newHash = _calculateHistoryListHash(events);
    final lastHash = keyBox.get(_historyEventsHashKey, defaultValue: -1);

    bool boxValid = true;
    try {
      for (final dynamic val in eventsBox.values.cast<dynamic>()) {
        if (val is! HistoryEventHive) {
          boxValid = false;
          break;
        }
      }
    } catch (_) {
      boxValid = false;
    }

    if (lastHash == newHash && boxValid && eventsBox.isNotEmpty) {
      logger.d("same json, don´t import history");
      return;
    }

    await eventsBox.clear();
    await eventsBox.addAll(events);
    await keyBox.put(_historyEventsHashKey, newHash);
  }

  static List<HistoryEventHive> getHistoryEventsSortedByDate() {
    try {
      final eventsBox = Hive.box<HistoryEventHive>(_historyEventsBox);
      return eventsBox.values.toList()
        ..sort((a, b) => b.date.compareTo(a.date));
    } catch (e) {
      logger.e('Failed to read history events from Hive: $e');
      return [];
    }
  }
}

int _calculateFutureListHash(List<FutureEventHive> events) {
  return events.fold(0, (hash, event) {
    final eventJson = event.toDto().toJson();
    return hash ^ jsonEncode(eventJson).hashCode;
  });
}

int _calculateHistoryListHash(List<HistoryEventHive> events) {
  return events.fold(0, (hash, event) {
    final eventJson = event.toDto().toJson();
    return hash ^ jsonEncode(eventJson).hashCode;
  });
}
