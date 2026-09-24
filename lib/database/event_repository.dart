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

    // 1. 注册 Hive CE 生成的 EventHiveAdapter
    Hive.registerAdapter(EventHiveAdapter());

    // 2. 打开指定强类型的 Box
    await Hive.openBox<EventHive>(_historyEventsBox);
    await Hive.openBox<EventHive>(_futureEventsBox);
    await Hive.openBox(_futureHashKeyBox);
    await Hive.openBox(_historyHashKeyBox);
  }

  static Future<void> importFutureEvents(List<Map<String, dynamic>> futureEvents) async {
    // 使用 EventDto.fromJson 解析 JSON，并转换为 EventHive 存储对象
    final events = futureEvents
        .map((data) => EventDto.fromJson(data).toHive())
        .toList();

    final eventsBox = Hive.box<EventHive>(_futureEventsBox);
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

  static List<EventHive> getFutureEventsSortedByDate() {
    return Hive.box<EventHive>(_futureEventsBox)
        .values
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  static Future<void> importHistoryEvents(List<Map<String, dynamic>> historyEvents) async {
    final events = historyEvents
        .map((data) => EventDto.fromJson(data).toHive())
        .toList();

    final eventsBox = Hive.box<EventHive>(_historyEventsBox);
    final keyBox = Hive.box(_historyHashKeyBox);

    final newHash = _calculateListHash(events);
    final lastHash = keyBox.get(_historyEventsHashKey, defaultValue: -1);
    if (lastHash == newHash) {
      logger.d("same json, don´t import");
      return;
    }

    await eventsBox.clear();
    await eventsBox.addAll(events);
    await keyBox.put(_historyEventsHashKey, newHash);
  }

  static List<EventHive> getHistoryEventsSortedByDate() {
    return Hive.box<EventHive>(_historyEventsBox)
        .values
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }
}

int _calculateListHash(List<EventHive> events) {
  return events.fold(0, (hash, event) {
    final eventJson = event.toDto().toJson();
    return hash ^ jsonEncode(eventJson).hashCode;
  });
}