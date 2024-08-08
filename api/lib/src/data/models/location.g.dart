// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Location',
      json,
      ($checkedConvert) {
        final val = Location(
          lat: $checkedConvert('lat', (v) => (v as num).toDouble()),
          lng: $checkedConvert('lng', (v) => (v as num).toDouble()),
        );
        return val;
      },
    );

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
    };
