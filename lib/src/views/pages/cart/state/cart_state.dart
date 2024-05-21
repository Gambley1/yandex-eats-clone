import 'package:papa_burger/src/models/models.dart';

abstract class CartState {
  const CartState();
}

class CartStataeLoading extends CartState {
  const CartStataeLoading();
}

class CartStateError extends CartState {
  const CartStateError(this.error);
  final Object error;
}

class CartStateEmpty extends CartState {
  const CartStateEmpty();
}

class CartStateWithItems extends CartState {
  const CartStateWithItems(this.cart);

  final Cart cart;
}
