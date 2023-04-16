import 'package:equatable/equatable.dart' show Equatable;
import 'package:papa_burger/src/restaurant.dart'
    show CartBlocTest, GoogleRestaurant, Item, Restaurant, currency;
import 'package:flutter/foundation.dart' show immutable;

@immutable
class Cart extends Equatable {
  final String restaurantPlaceId;
  final Set<Item> cartItems;
  final Map<Item, int> itemsTest;

  const Cart({
    this.restaurantPlaceId = '',
    this.cartItems = const <Item>{},
    this.itemsTest = const <Item, int>{},
  });

  Cart copyWith({
    String? restaurantPlaceId,
    Set<Item>? cartItems,
    Map<Item, int>? itemsTest,
  }) =>
      Cart(
        cartItems: cartItems ?? this.cartItems,
        restaurantPlaceId: restaurantPlaceId ?? this.restaurantPlaceId,
        itemsTest: itemsTest ?? this.itemsTest,
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

  List<List<Item>> listGoogleRestaurantItems(
          GoogleRestaurant restaurant, Set<Item> items) =>
      restaurant.menu
          .map((menu) => menu.items
              .where((menuItem) => !items.contains(menuItem))
              .toList())
          .toList();

  List<Item> moreItemsToAdd(Restaurant restaurant, Set<Item> items) =>
      listItems(restaurant, items).expand((item) => item).toList();

  List<Item> moreItemsToAddWithGoogleRestaurant(
          GoogleRestaurant restaurant, Set<Item> items) =>
      listGoogleRestaurantItems(restaurant, items)
          .expand((item) => item)
          .toList();

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

    return _calcPrice(item, itemPrice);
  }

  // calculatin price, checking whether item has discount and returning a price
  // with or witouht discount.
  double discountPriceWithGoogleRestaurant({
    required int index,
    required GoogleRestaurant restaurant,
    required Set<Item> items,
  }) {
    final listItems = moreItemsToAddWithGoogleRestaurant(restaurant, items);
    final item = listItems[index];
    final double itemPrice = item.price;

    return _calcPrice(item, itemPrice);
  }

  static double _calcPrice(Item item, double itemPrice) {
    if (item.discount == 0) return itemPrice;

    final double itemDiscount = item.discount;
    assert(itemDiscount <= 100);

    if (itemDiscount > 100) return 0;

    final double discount = itemPrice * (itemDiscount / 100);
    final double discountPrice = itemPrice - discount;

    return discountPrice;
  }

  int quantity(Item item, CartBlocTest cartBlocTest) {
    return cartBlocTest.value.itemsTest[item] ?? 0;
  }

  // calculatin price, checking whether item has discount and returning a price
  // with or witouht discount.
  static double priceOfCartItems(
    // int index,
    List<Item> items,
  ) {
    double price = 0;
    // final Item item = items[index];
    for (final item in items) {
      final double itemPrice = item.price;

      price = _calcPrice(item, itemPrice);
    }
    return price;
  }

  double _subTotal() {
    final List<Item> listCartItems = List.from(cartItems);
    // calculating total
    // if item has discount, calculates total with item's, calculated with discount, price
    // if not, just summ it's default price.
    priceByQuantity(Item item) => item.price * itemsTest[item]!;

    num itemPrice(Item current) {
      return current.discount == 0
          ? priceByQuantity(current)
          : (priceByQuantity(current) -
              current.price * (current.discount / 100));
    }

    final double total = listCartItems.fold(
      0,
      (total, current) => total + itemPrice(current),
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

  String totalSumm() => '${totalWithDeliveryFee().toStringAsFixed(0)}\$';

  double get _toFreeDelivery {
    final needMore = _minimumSubTotal - _subTotal();
    return needMore;
  }

  bool get freeDelivery => _toFreeDelivery < 0.2;

  String get toFreeDeliveryString =>
      '${_toFreeDelivery.toStringAsFixed(0)}$currency';

  @override
  List<Object?> get props => [
        restaurantPlaceId,
        cartItems,
        itemsTest,
      ];
}
