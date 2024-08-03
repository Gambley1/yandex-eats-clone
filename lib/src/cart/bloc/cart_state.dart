part of 'cart_bloc.dart';

enum CartStatus {
  initial,
  loading,
  success,
  failure,
  createOrderLoading,
  createOrderSuccess,
  createOrderFailure;
}

class CartItemsJsonConverter
    implements JsonConverter<Map<MenuItem, int>, Map<String, dynamic>> {
  const CartItemsJsonConverter();

  @override
  Map<String, dynamic> toJson(Map<MenuItem, int> cartItems) {
    final json = <String, dynamic>{};
    for (final entry in cartItems.entries) {
      json[jsonEncode(entry.key.toJson())] = entry.value;
    }
    return json;
  }

  @override
  Map<MenuItem, int> fromJson(Map<String, dynamic> json) {
    final cartItems = <MenuItem, int>{};
    for (final entry in json.entries) {
      final item =
          MenuItem.fromJson(jsonDecode(entry.key) as Map<String, dynamic>);
      cartItems[item] = entry.value as int;
    }
    return cartItems;
  }
}

@JsonSerializable()
class CartState extends Equatable {
  const CartState({
    required this.restaurant,
    required this.cartItems,
    this.status = CartStatus.initial,
  });

  const CartState.initial()
      : this(status: CartStatus.initial, restaurant: null, cartItems: const {});

  factory CartState.fromJson(Map<String, dynamic> json) =>
      _$CartStateFromJson(json);

  Map<String, dynamic> toJson() => _$CartStateToJson(this);

  static const _maxItemQuantity = 100;
  static const _minSubTotal = 30;
  static const _deliveryFee = 5;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final CartStatus status;
  final Restaurant? restaurant;
  @CartItemsJsonConverter()
  final Map<MenuItem, int> cartItems;

  List<MenuItem> get items => cartItems.keys.toList();

  bool get isCartEmpty => items.isEmpty;
  int quantity(MenuItem item) => cartItems[item] ?? 0;
  bool isInCart(MenuItem item) => items.contains(item);

  bool canIncreaseItemQuantity(MenuItem item) =>
      cartItems[item] != null && (cartItems[item] ?? 0) < _maxItemQuantity;

  double get _subTotal {
    double calculatePriceWithDiscountAndQuantity(MenuItem item) {
      final quantity = cartItems[item]!;
      if (item.discount == 0) return item.price * quantity;
      final priceWithDiscount =
          item.price - (item.price * (item.discount / 100));
      return priceWithDiscount * quantity;
    }

    return items.fold<double>(
      0,
      (total, current) =>
          total + calculatePriceWithDiscountAndQuantity(current),
    );
  }

  double get subTotal => _subTotal;

  int get orderDeliveryFee => subTotalGreaterMinPrice ? 0 : _deliveryFee;

  String get formattedDeliveryFee => _deliveryFee.currencyFormat();

  bool get subTotalGreaterMinPrice => _subTotal > _minSubTotal;

  double _totalDelivery() {
    if (orderDeliveryFee == 0) return _subTotal;
    return _subTotal + orderDeliveryFee;
  }

  String get formattedOrderDeliveryFee => orderDeliveryFee.currencyFormat();

  String formattedTotalDelivery() => _totalDelivery().currencyFormat();

  String totalDeliveryRound() => _totalDelivery().toStringAsFixed(2);

  double get _sumLeftToFreeDelivery => _minSubTotal - _subTotal;

  bool get isDeliveryFree => _sumLeftToFreeDelivery < 0;

  String get sumLeftToFreeDelivery => _sumLeftToFreeDelivery.currencyFormat();

  @override
  List<Object?> get props => [status, cartItems, restaurant];

  CartState copyWith({
    CartStatus? status,
    Restaurant? restaurant,
    Map<MenuItem, int>? cartItems,
  }) {
    return CartState(
      status: status ?? this.status,
      restaurant: restaurant ?? this.restaurant,
      cartItems: cartItems ?? this.cartItems,
    );
  }

  CartState reset({
    required bool withCart,
  }) =>
      CartState(
        status: status,
        restaurant: null,
        cartItems: withCart ? {} : cartItems,
      );
}
