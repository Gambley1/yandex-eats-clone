// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Order',
      json,
      ($checkedConvert) {
        final val = Order(
          id: $checkedConvert('id', (v) => v as String),
          status: $checkedConvert('status',
              (v) => const OrderStatusJsonConverter().fromJson(v as String)),
          date: $checkedConvert('date', (v) => v as String),
          restaurantPlaceId:
              $checkedConvert('restaurant_place_id', (v) => v as String),
          restaurantName:
              $checkedConvert('restaurant_name', (v) => v as String),
          address: $checkedConvert('address', (v) => v as String),
          items: $checkedConvert(
              'items',
              (v) => (v as List<dynamic>)
                  .map((e) => OrderMenuItem.fromJson(e as Map<String, dynamic>))
                  .toList()),
          totalOrderSum:
              $checkedConvert('total_order_sum', (v) => (v as num).toDouble()),
          deliveryFee:
              $checkedConvert('delivery_fee', (v) => (v as num).toDouble()),
        );
        return val;
      },
      fieldKeyMap: const {
        'restaurantPlaceId': 'restaurant_place_id',
        'restaurantName': 'restaurant_name',
        'totalOrderSum': 'total_order_sum',
        'deliveryFee': 'delivery_fee'
      },
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'status': const OrderStatusJsonConverter().toJson(instance.status),
      'date': instance.date,
      'restaurant_place_id': instance.restaurantPlaceId,
      'restaurant_name': instance.restaurantName,
      'address': instance.address,
      'items': instance.items.map((e) => e.toJson()).toList(),
      'total_order_sum': instance.totalOrderSum,
      'delivery_fee': instance.deliveryFee,
    };
