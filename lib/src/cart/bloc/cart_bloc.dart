import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:orders_repository/orders_repository.dart';
import 'package:restaurants_repository/restaurants_repository.dart';
import 'package:shared/shared.dart';
import 'package:user_repository/user_repository.dart';
import 'package:yandex_food_api/api.dart';
import 'package:yandex_food_api/client.dart';

part 'cart_bloc.g.dart';
part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends HydratedBloc<CartEvent, CartState> {
  CartBloc({
    required RestaurantsRepository restaurantsRepository,
    required OrdersRepository ordersRepository,
    required NotificationsRepository notificationsRepository,
    required UserRepository userRepository,
  })  : _restaurantsRepository = restaurantsRepository,
        _ordersRepository = ordersRepository,
        _notificationsRepository = notificationsRepository,
        _userRepository = userRepository,
        super(const CartState.initial()) {
    on<CartAddItemRequested>(_onCartAddItemRequested);
    on<CartRemoveItemRequested>(_onCartRemoveItemRequested);
    on<CartItemIncreaseQuantityRequested>(_onCartItemIncreaseQuantityRequested);
    on<CartItemDecreaseQuantityRequested>(_onCartItemDecreaseQuantityRequested);
    on<CartClearRequested>(_onCartClearRequested);
    on<CartPlaceOrderRequested>(_onCartPlaceOrderRequested);
  }

  final RestaurantsRepository _restaurantsRepository;
  final OrdersRepository _ordersRepository;
  final NotificationsRepository _notificationsRepository;
  final UserRepository _userRepository;

  Future<void> _onCartAddItemRequested(
    CartAddItemRequested event,
    Emitter<CartState> emit,
  ) async {
    try {
      final item =
          state.items.firstWhereOrNull((item) => item.name == event.item.name);
      if (item != null) {
        return add(CartItemIncreaseQuantityRequested(item: event.item));
      }
      final restaurant = !state.isCartEmpty
          ? null
          : await _restaurantsRepository.getRestaurant(
              id: event.restaurantPlaceId,
              location: _userRepository.fetchCurrentLocation(),
            );
      emit(
        state.copyWith(
          restaurant: restaurant,
          cartItems: {...state.cartItems}
            ..putIfAbsent(event.item, () => event.amount ?? 1),
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: CartStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> _onCartRemoveItemRequested(
    CartRemoveItemRequested event,
    Emitter<CartState> emit,
  ) async {
    final cartItems = state.cartItems;
    try {
      final newCartItems = {...cartItems}..remove(event.item);
      emit(state.copyWith(status: CartStatus.loading));
      emit(
        state.copyWith(
          cartItems: newCartItems,
          status: CartStatus.success,
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: CartStatus.failure, cartItems: cartItems));
      addError(error, stackTrace);
    }
  }

  Future<void> _onCartItemIncreaseQuantityRequested(
    CartItemIncreaseQuantityRequested event,
    Emitter<CartState> emit,
  ) async {
    try {
      if (!state.canIncreaseItemQuantity(event.item)) return;
      int effectiveAmount(int value) {
        return event.amount != null
            ? event.amount! + value > CartState._maxItemQuantity
                ? CartState._maxItemQuantity - value
                : event.amount!
            : 1;
      }

      emit(
        state.copyWith(
          cartItems: {...state.cartItems}..update(
              event.item,
              (value) => value + effectiveAmount(value),
            ),
          status: CartStatus.success,
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: CartStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> _onCartItemDecreaseQuantityRequested(
    CartItemDecreaseQuantityRequested event,
    Emitter<CartState> emit,
  ) async {
    final quantity = state.quantity(event.item);
    if (quantity == 0) return;

    Future<void> removeItem() async {
      add(CartRemoveItemRequested(item: event.item));
    }

    try {
      if (quantity > 1) {
        emit(
          state.copyWith(
            cartItems: {...state.cartItems}
              ..update(event.item, (value) => value - 1),
            status: CartStatus.success,
          ),
        );
      } else {
        await removeItem().whenComplete(() {
          if (!state.isCartEmpty) return;
          event.goToMenu?.call(state.restaurant);
          emit(state.reset(withCart: false));
        });
      }
    } catch (error, stackTrace) {
      emit(
        state.copyWith(
          status: CartStatus.failure,
          cartItems: {...state.cartItems}
            ..putIfAbsent(event.item, () => quantity),
        ),
      );
      addError(error, stackTrace);
    }
  }

  Future<void> _onCartClearRequested(
    CartClearRequested event,
    Emitter<CartState> emit,
  ) async {
    try {
      event.goToMenu?.call(state.restaurant);
      emit(state.reset(withCart: true));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: CartStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> _onCartPlaceOrderRequested(
    CartPlaceOrderRequested event,
    Emitter<CartState> emit,
  ) async {
    try {
      emit(state.copyWith(status: CartStatus.createOrderLoading));

      final now = DateTime.now();
      final createdAt = now.ddMMMMHHMM();
      final restaurant = state.restaurant!;

      final deliveryTime = restaurant.deliveryTime;
      final deliverByWalk = deliveryTime < 8;
      final deliveryDate = now
          .add(Duration(minutes: (deliverByWalk ? 15 : deliveryTime) + 10))
          .hhMM();

      final restaurantName = restaurant.name;
      final totalOrderSum = state.totalDeliveryRound();
      final orderDeliveryFee = state.orderDeliveryFee.toString();
      final orderId = await _ordersRepository.createOrder(
        createdAt: createdAt,
        restaurantPlaceId: restaurant.placeId,
        restaurantName: restaurantName,
        orderAddress: event.orderAddress.toString(),
        totalOrderSum: totalOrderSum,
        orderDeliveryFee: orderDeliveryFee,
      );
      await Future.wait(
        state.items.map((item) {
          return _ordersRepository.addOrderMenuItem(
            orderId: orderId,
            imageUrl: item.imageUrl,
            name: item.name,
            price: item.priceWithDiscount.toStringAsFixed(2),
            quantity: state.quantity(item).toString(),
          );
        }).toList(),
      );
      unawaited(
        _notificationsRepository.showNotification(
          isOngoing: true,
          body: 'Your order №$orderId has been successfully formed! '
              ' It will be delivered by $deliveryDate.',
        ),
      );
      add(const CartClearRequested());
      emit(state.copyWith(status: CartStatus.createOrderSuccess));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: CartStatus.createOrderFailure));
      addError(error, stackTrace);
    }
  }

  @override
  CartState? fromJson(Map<String, dynamic> json) => CartState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(CartState state) => state.toJson();
}
