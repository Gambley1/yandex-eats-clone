import 'package:papa_burger/src/restaurant.dart'
    show CartBloc, CartBlocTest;

class CartService {
  late final CartBloc cartBloc;
  late final CartBlocTest cartBlocTest;

  CartService() {
    cartBloc = CartBloc();
    cartBlocTest = CartBlocTest();
  }
}
