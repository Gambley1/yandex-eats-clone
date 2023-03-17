import 'package:equatable/equatable.dart' show Equatable;
import 'package:papa_burger/src/restaurant.dart' show GoogleRestaurant, Item, Restaurant;
import 'package:flutter/foundation.dart' show immutable;

@immutable
class Cart extends Equatable {
  final int restaurantId;
  final Set<Item> cartItems;

  const Cart({
    this.restaurantId = 0,
    this.cartItems = const <Item>{},
  });

  Cart copyWith({
    int? restaurantId,
    Set<Item>? cartItems,
  }) =>
      Cart(
        cartItems: cartItems ?? this.cartItems,
        restaurantId: restaurantId ?? this.restaurantId,
      );

  int get _minimumSubTotal => 30;
  int get deliveryFee => 10;
  bool get cartEmpty => cartItems.toList().isEmpty;

  List<List<Item>> listItems(Restaurant restaurant, Set<Item> items) =>
      restaurant.menu
          .map((menu) => menu.items
              .where((menuItem) => !items.contains(menuItem))
              .toList())
          .toList();

          List<List<Item>> listGoogleRestaurantItems(GoogleRestaurant restaurant, Set<Item> items) =>
      restaurant.menu
          .map((menu) => menu.items
              .where((menuItem) => !items.contains(menuItem))
              .toList())
          .toList();

  List<Item> moreItemsToAdd(Restaurant restaurant, Set<Item> items) =>
      listItems(restaurant, items).expand((item) => item).toList();

      List<Item> moreItemsToAddWithGoogleRestaurant(GoogleRestaurant restaurant, Set<Item> items) =>
      listGoogleRestaurantItems(restaurant, items).expand((item) => item).toList();

  Map itemQuantity(List<Item> cartItems) {
    var quantity = {};

    for (var item in cartItems) {
      if (!quantity.containsKey(item)) {
        quantity[item] = 1;
      } else {
        quantity[item] += 1;
      }
    }

    return quantity;
  }

  // calculatin price, checking whether item has discount and returning a price
  // with or witouht discount;
  double discountPrice({
    required int index,
    required Restaurant restaurant,
    required Set<Item> items,
  }) {
    final listItems = moreItemsToAdd(restaurant, items);
    final item = listItems[index];
    final double itemPrice = item.price;

    if (item.discount == 0) return itemPrice;

    final double itemDiscount = item.discount;
    assert(itemDiscount <= 100);

    if (itemDiscount > 100) return 0;

    final double discount = itemPrice * (itemDiscount / 100);
    final double discountPrice = itemPrice - discount;

    return discountPrice;
  }

  // calculatin price, checking whether item has discount and returning a price
  // with or witouht discount;
  double discountPriceWithGoogleRestaurant({
    required int index,
    required GoogleRestaurant restaurant,
    required Set<Item> items,
  }) {
    final listItems = moreItemsToAddWithGoogleRestaurant(restaurant, items);
    final item = listItems[index];
    final double itemPrice = item.price;

    if (item.discount == 0) return itemPrice;

    final double itemDiscount = item.discount;
    assert(itemDiscount <= 100);

    if (itemDiscount > 100) return 0;

    final double discount = itemPrice * (itemDiscount / 100);
    final double discountPrice = itemPrice - discount;

    return discountPrice;
  }

  // calculatin price, checking whether item has discount and returning a price
  // with or witouht discount;
  double priceOfCartItems({
    required int index,
    required List<Item> items,
  }) {
    final Item item = items[index];
    final double itemPrice = item.price;

    if (item.discount == 0) return itemPrice;

    final double itemDiscount = item.discount;
    assert(itemDiscount <= 100);

    if (itemDiscount > 100) return 0;

    final double discount = itemPrice * (itemDiscount / 100);
    final double discountPrice = itemPrice - discount;

    return discountPrice;
  }

  double _subTotal() {
    final List<Item> listCartItems = List.from(cartItems);
    // calculating total
    // if item has discount, calculates total with item's, calculated with discount, price
    // if not, just summ it's default price.
    final double total = listCartItems.fold(
      0,
      (total, current) =>
          total +
          (current.discount == 0
              ? current.price
              : (current.price - current.price * (current.discount / 100))),
    );
    return total;
  }

  int get _getDeliveryFee => _subTotal() < _minimumSubTotal ? deliveryFee : 0;

  bool get greaterThanMinimumPrice => _minimumSubTotal < _subTotal();

  double totalWithDeliveryFee() {
    if (_getDeliveryFee == 0) return _subTotal();
    return _subTotal() + _getDeliveryFee;
  }

  String get deliveryFeeString {
    return '$deliveryFee\$';
  }

  @override
  List<Object?> get props => [
        restaurantId,
        cartItems,
      ];
}
