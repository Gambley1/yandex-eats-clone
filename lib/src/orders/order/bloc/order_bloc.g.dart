// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'order_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderState _$OrderStateFromJson(Map<String, dynamic> json) => $checkedCreate(
      'OrderState',
      json,
      ($checkedConvert) {
        final val = OrderState(
          order: $checkedConvert(
              'order',
              (v) =>
                  v == null ? null : Order.fromJson(v as Map<String, dynamic>)),
          restaurant: $checkedConvert(
              'restaurant',
              (v) => v == null
                  ? null
                  : Restaurant.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

Map<String, dynamic> _$OrderStateToJson(OrderState instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('order', instance.order?.toJson());
  writeNotNull('restaurant', instance.restaurant?.toJson());
  return val;
}
