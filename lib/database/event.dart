import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'event.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class Event {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String date;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String imageWeb;

  @HiveField(5)
  final String imageMobile;

  Event({this.id = '',
    this.title = '',
    this.date = '',
    this.description = '',
    this.imageWeb = '',
    this.imageMobile = ''});

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
  Map<String, dynamic> toJson() => _$EventToJson(this);
}

