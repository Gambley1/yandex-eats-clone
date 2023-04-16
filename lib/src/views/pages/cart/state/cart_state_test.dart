import 'package:papa_burger/src/restaurant.dart' show Cart;

abstract class CartStateTest {
  const CartStateTest();
}

class CartStataeLoading extends CartStateTest {
  const CartStataeLoading();
}

class CartStateError extends CartStateTest {
  final Object error;
  const CartStateError(this.error);
}

class CartStateEmpty extends CartStateTest {
  const CartStateEmpty();
}

class CartStateWithItems extends CartStateTest {
  final Cart cart;
  const CartStateWithItems(this.cart);
}
