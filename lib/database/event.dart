import 'package:json_annotation/json_annotation.dart';
import 'package:hive_ce/hive.dart';

part 'event.g.dart';

@JsonSerializable()
class FutureEventDto {
  final String id;
  final String title;
  final String date;
  final String dateText;
  final String location;
  final String brand;

  FutureEventDto({
    this.id = '',
    this.title = '',
    this.date = '',
    this.dateText = '',
    this.location = '',
    this.brand = '',
  });

  factory FutureEventDto.fromJson(Map<String, dynamic> json) => _$FutureEventDtoFromJson(json);
  Map<String, dynamic> toJson() => _$FutureEventDtoToJson(this);

  FutureEventHive toHive() {
    return FutureEventHive(
      id: id,
      title: title,
      date: date,
      dateText: dateText,
      location: location,
      brand: brand,
    );
  }
}

@HiveType(typeId: 0)
class FutureEventHive {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String date;

  @HiveField(3)
  final String dateText;

  @HiveField(4)
  final String location;

  @HiveField(5)
  final String brand;

  FutureEventHive({
    this.id = '',
    this.title = '',
    this.date = '',
    this.dateText = '',
    this.location = '',
    this.brand = '',
  });

  FutureEventDto toDto() {
    return FutureEventDto(
      id: id,
      title: title,
      date: date,
      dateText: dateText,
      location: location,
      brand: brand,
    );
  }
}

@JsonSerializable()
class HistoryEventDto {
  final String id;
  final String title;
  final String date;
  final String dateText;
  final String description;
  final String imageWeb;
  final String imageMobile;

  HistoryEventDto({
    this.id = '',
    this.title = '',
    this.date = '',
    this.dateText = '',
    this.description = '',
    this.imageWeb = '',
    this.imageMobile = '',
  });

  factory HistoryEventDto.fromJson(Map<String, dynamic> json) => _$HistoryEventDtoFromJson(json);
  Map<String, dynamic> toJson() => _$HistoryEventDtoToJson(this);

  HistoryEventHive toHive() {
    return HistoryEventHive(
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

@HiveType(typeId: 1)
class HistoryEventHive {
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

  HistoryEventHive({
    this.id = '',
    this.title = '',
    this.date = '',
    this.dateText = '',
    this.description = '',
    this.imageWeb = '',
    this.imageMobile = '',
  });

  HistoryEventDto toDto() {
    return HistoryEventDto(
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
