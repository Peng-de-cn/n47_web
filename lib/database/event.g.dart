// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventAdapter extends TypeAdapter<Event> {
  @override
  final int typeId = 0;

  @override
  Event read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Event(
      id: fields[0] as String,
      title: fields[1] as String,
      date: fields[2] as String,
      dateText: fields[3] as String,
      description: fields[4] as String,
      imageWeb: fields[5] as String,
      imageMobile: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Event obj) {
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
      other is EventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      date: json['date'] as String? ?? '',
      dateText: json['dateText'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageWeb: json['imageWeb'] as String? ?? '',
      imageMobile: json['imageMobile'] as String? ?? '',
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'date': instance.date,
      'dateText': instance.dateText,
      'description': instance.description,
      'imageWeb': instance.imageWeb,
      'imageMobile': instance.imageMobile,
    };
