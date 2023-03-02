import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/restaurant.dart';

enum CartStatus { initial, loading, succes, error }

@immutable
class CartState extends Equatable {
  const CartState({
    this.cart = const Cart(),
    this.cartStatus = CartStatus.initial,
  });
  final Cart cart;
  final CartStatus cartStatus;

  CartState copyWith({
    Cart? cart,
    CartStatus? cartStatus,
  }) {
    return CartState(
      cart: cart ?? this.cart,
      cartStatus: cartStatus ?? this.cartStatus,
    );
  }

  @override
  List<Object?> get props => <Object?>[cart, cartStatus];
}
