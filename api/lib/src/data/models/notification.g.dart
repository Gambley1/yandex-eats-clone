// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notification _$NotificationFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'Notification',
      json,
      ($checkedConvert) {
        final val = Notification(
          id: $checkedConvert('id', (v) => (v as num).toInt()),
          message: $checkedConvert('message', (v) => v as String),
          date: $checkedConvert('date', (v) => v as String),
          isImportant: $checkedConvert('is_important', (v) => v as bool?),
        );
        return val;
      },
      fieldKeyMap: const {'isImportant': 'is_important'},
    );

Map<String, dynamic> _$NotificationToJson(Notification instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'message': instance.message,
    'date': instance.date,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('is_important', instance.isImportant);
  return val;
}
