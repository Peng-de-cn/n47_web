import 'package:json_annotation/json_annotation.dart';
import 'package:hive_ce/hive.dart';

part 'event.g.dart';

@JsonSerializable()
class EventDto {
  final String id;
  final String title;
  final String date;
  final String dateText;
  final String description;
  final String imageWeb;
  final String imageMobile;

  EventDto({
    this.id = '',
    this.title = '',
    this.date = '',
    this.dateText = '',
    this.description = '',
    this.imageWeb = '',
    this.imageMobile = '',
  });

  factory EventDto.fromJson(Map<String, dynamic> json) => _$EventDtoFromJson(json);
  Map<String, dynamic> toJson() => _$EventDtoToJson(this);

  EventHive toHive() {
    return EventHive(
      id: id,
      title: title,
      date: date,
      dateText: dateText,
      description: description,
      imageWeb: imageWeb,
      imageMobile: imageMobile,
    );
  }
}

@HiveType(typeId: 0)
class EventHive {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String date;

  @HiveField(3)
  final String dateText;

  @HiveField(4)
  final String description;

  @HiveField(5)
  final String imageWeb;

  @HiveField(6)
  final String imageMobile;

  EventHive({
    this.id = '',
    this.title = '',
    this.date = '',
    this.dateText = '',
    this.description = '',
    this.imageWeb = '',
    this.imageMobile = '',
  });

  EventDto toDto() {
    return EventDto(
      id: id,
      title: title,
      date: date,
      dateText: dateText,
      description: description,
      imageWeb: imageWeb,
      imageMobile: imageMobile,
    );
  }
}
