part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

final class CartAddItemRequested extends CartEvent {
  const CartAddItemRequested({
    required this.item,
    required this.restaurantPlaceId,
    this.amount,
  });

  final MenuItem item;
  final int? amount;
  final String restaurantPlaceId;
}

final class CartRemoveItemRequested extends CartEvent {
  const CartRemoveItemRequested({required this.item});

  final MenuItem item;
}

final class CartItemIncreaseQuantityRequested extends CartEvent {
  const CartItemIncreaseQuantityRequested({required this.item, this.amount});

  final MenuItem item;
  final int? amount;
}

final class CartItemDecreaseQuantityRequested extends CartEvent {
  const CartItemDecreaseQuantityRequested({
    required this.item,
    this.goToMenu,
  });

  final MenuItem item;
  final ValueSetter<Restaurant?>? goToMenu;
}

final class CartClearRequested extends CartEvent {
  const CartClearRequested({this.goToMenu});

  final ValueSetter<Restaurant?>? goToMenu;
}

final class CartPlaceOrderRequested extends CartEvent {
  const CartPlaceOrderRequested({required this.orderAddress});

  final Address orderAddress;
}
