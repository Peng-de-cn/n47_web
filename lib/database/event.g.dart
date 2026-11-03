// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FutureEventHiveAdapter extends TypeAdapter<FutureEventHive> {
  @override
  final typeId = 0;

  @override
  FutureEventHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FutureEventHive(
      id: fields[0] == null ? '' : fields[0] as String,
      title: fields[1] == null ? '' : fields[1] as String,
      date: fields[2] == null ? '' : fields[2] as String,
      dateText: fields[3] == null ? '' : fields[3] as String,
      location: fields[4] == null ? '' : fields[4] as String,
      brand: fields[5] == null ? '' : fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FutureEventHive obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.dateText)
      ..writeByte(4)
      ..write(obj.location)
      ..writeByte(5)
      ..write(obj.brand);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FutureEventHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HistoryEventHiveAdapter extends TypeAdapter<HistoryEventHive> {
  @override
  final typeId = 1;

  @override
  HistoryEventHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HistoryEventHive(
      id: fields[0] == null ? '' : fields[0] as String,
      title: fields[1] == null ? '' : fields[1] as String,
      date: fields[2] == null ? '' : fields[2] as String,
      dateText: fields[3] == null ? '' : fields[3] as String,
      description: fields[4] == null ? '' : fields[4] as String,
      imageWeb: fields[5] == null ? '' : fields[5] as String,
      imageMobile: fields[6] == null ? '' : fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HistoryEventHive obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.dateText)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.imageWeb)
      ..writeByte(6)
      ..write(obj.imageMobile);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryEventHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FutureEventDto _$FutureEventDtoFromJson(Map<String, dynamic> json) =>
    FutureEventDto(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      date: json['date'] as String? ?? '',
      dateText: json['dateText'] as String? ?? '',
      location: json['location'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
    );

Map<String, dynamic> _$FutureEventDtoToJson(FutureEventDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'date': instance.date,
      'dateText': instance.dateText,
      'location': instance.location,
      'brand': instance.brand,
    };

HistoryEventDto _$HistoryEventDtoFromJson(Map<String, dynamic> json) =>
    HistoryEventDto(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      date: json['date'] as String? ?? '',
      dateText: json['dateText'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageWeb: json['imageWeb'] as String? ?? '',
      imageMobile: json['imageMobile'] as String? ?? '',
    );

Map<String, dynamic> _$HistoryEventDtoToJson(HistoryEventDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'date': instance.date,
      'dateText': instance.dateText,
      'description': instance.description,
      'imageWeb': instance.imageWeb,
      'imageMobile': instance.imageMobile,
    };
