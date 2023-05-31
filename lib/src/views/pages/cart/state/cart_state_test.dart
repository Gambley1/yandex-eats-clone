import 'package:papa_burger/src/restaurant.dart' show Cart;

abstract class CartStateTest {
  const CartStateTest();
}

class CartStataeLoading extends CartStateTest {
  const CartStataeLoading();
}

class CartStateError extends CartStateTest {
  const CartStateError(this.error);
  final Object error;
}

class CartStateEmpty extends CartStateTest {
  const CartStateEmpty();
}

class CartStateWithItems extends CartStateTest {
  const CartStateWithItems(this.cart);
  final Cart cart;
}
