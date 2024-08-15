// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'menu_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuItem _$MenuItemFromJson(Map<String, dynamic> json) => $checkedCreate(
      'MenuItem',
      json,
      ($checkedConvert) {
        final val = MenuItem(
          id: $checkedConvert('id', (v) => (v as num).toInt()),
          name: $checkedConvert('name', (v) => v as String),
          description: $checkedConvert('description', (v) => v as String),
          imageUrl: $checkedConvert('image_url', (v) => v as String),
          price: $checkedConvert('price', (v) => (v as num).toDouble()),
          discount: $checkedConvert('discount', (v) => (v as num).toDouble()),
        );
        return val;
      },
      fieldKeyMap: const {'imageUrl': 'image_url'},
    );

Map<String, dynamic> _$MenuItemToJson(MenuItem instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'image_url': instance.imageUrl,
      'price': instance.price,
      'discount': instance.discount,
    };
