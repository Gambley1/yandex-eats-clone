// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'orders_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrdersState _$OrdersStateFromJson(Map<String, dynamic> json) => $checkedCreate(
      'OrdersState',
      json,
      ($checkedConvert) {
        final val = OrdersState(
          orders: $checkedConvert(
              'orders',
              (v) => (v as List<dynamic>)
                  .map((e) => Order.fromJson(e as Map<String, dynamic>))
                  .toList()),
          hasPendingOrders:
              $checkedConvert('has_pending_orders', (v) => v as bool),
        );
        return val;
      },
      fieldKeyMap: const {'hasPendingOrders': 'has_pending_orders'},
    );

Map<String, dynamic> _$OrdersStateToJson(OrdersState instance) =>
    <String, dynamic>{
      'orders': instance.orders.map((e) => e.toJson()).toList(),
      'has_pending_orders': instance.hasPendingOrders,
    };
