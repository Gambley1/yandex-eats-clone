import 'package:equatable/equatable.dart' show Equatable;
import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/restaurant.dart' show Item, currency;

@immutable
class Cart extends Equatable {
  const Cart({
    this.restaurantPlaceId = '',
    this.cartItems = const <Item, int>{},
  });
  final String restaurantPlaceId;
  final Map<Item, int> cartItems;

  Cart copyWith({
    String? restaurantPlaceId,
    Map<Item, int>? cartItems,
  }) =>
      Cart(
        restaurantPlaceId: restaurantPlaceId ?? this.restaurantPlaceId,
        cartItems: cartItems ?? this.cartItems,
      );

  int get _minimumSubTotal => 30;
  int get deliveryFee => 10;
  Set<Item> get items => cartItems.keys.toSet();
  bool get cartEmpty => items.toList().isEmpty;
  int quantity(Item item) {
    return cartItems[item] ?? 0;
  }

  double _subTotal() {
    final items$ = items.toList();

    double priceWithQuantity(Item item) {
      final itemQuantity = cartItems[item]!;
      if (item.discount == 0) {
        final price = item.price * itemQuantity;
        return price;
      }
      final priceWithDiscount =
          item.price - (item.price * (item.discount / 100));
      return priceWithDiscount * itemQuantity;
    }

    final total = items$.fold<double>(
      0,
      (total, current) => total + priceWithQuantity(current),
    );
    return total;
  }

  int get getDeliveryFee => subTotalgreaterThanMinimumPrice ? 0 : deliveryFee;

  bool get subTotalgreaterThanMinimumPrice => _subTotal() > _minimumSubTotal;

  double totalWithDeliveryFee() {
    if (getDeliveryFee == 0) {
      return _subTotal();
    } else {
      return _subTotal() + getDeliveryFee;
    }
  }

  String get deliveryFeeString {
    return '$deliveryFee\$';
  }

  String totalSumm() => '${totalWithDeliveryFee().toStringAsFixed(2)}$currency';

  String totalRound() => '${totalWithDeliveryFee().round()}';

  double get _toFreeDelivery {
    final needMore = _minimumSubTotal - _subTotal();
    return needMore;
  }

  bool get freeDelivery => _toFreeDelivery < 0;

  String get toFreeDeliveryString =>
      '${_toFreeDelivery.toStringAsFixed(2)}$currency';

  @override
  List<Object?> get props => [
        restaurantPlaceId,
        cartItems,
      ];
}
