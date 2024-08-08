// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'order_menu_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderMenuItem _$OrderMenuItemFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'OrderMenuItem',
      json,
      ($checkedConvert) {
        final val = OrderMenuItem(
          id: $checkedConvert('id', (v) => (v as num).toInt()),
          name: $checkedConvert('name', (v) => v as String),
          quantity: $checkedConvert('quantity', (v) => (v as num).toInt()),
          price: $checkedConvert('price', (v) => (v as num).toDouble()),
          imageUrl: $checkedConvert('image_url', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'imageUrl': 'image_url'},
    );

Map<String, dynamic> _$OrderMenuItemToJson(OrderMenuItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'quantity': instance.quantity,
      'price': instance.price,
      'image_url': instance.imageUrl,
    };
