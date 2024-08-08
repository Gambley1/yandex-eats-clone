// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'menu.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Menu _$MenuFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Menu',
      json,
      ($checkedConvert) {
        final val = Menu(
          category: $checkedConvert('category', (v) => v as String),
          items: $checkedConvert(
              'items',
              (v) => (v as List<dynamic>)
                  .map((e) => MenuItem.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$MenuToJson(Menu instance) => <String, dynamic>{
      'category': instance.category,
      'items': instance.items.map((e) => e.toJson()).toList(),
    };
