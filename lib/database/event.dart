import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'event.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class Event {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String date;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String image;

  @HiveField(5)
  final bool isHistory;

  Event({required this.id,
    this.title = '',
    this.date = '',
    this.description = '',
    this.image = '',
    this.isHistory = false,});

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
  Map<String, dynamic> toJson() => _$EventToJson(this);
}

