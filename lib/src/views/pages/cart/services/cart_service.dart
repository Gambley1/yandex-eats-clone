import 'package:papa_burger/src/restaurant.dart';

class CartService {
  late final CartBloc cartBloc;

  CartService() {
    cartBloc = CartBloc();
  }
}
