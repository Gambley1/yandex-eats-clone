import 'package:papa_burger/src/restaurant.dart' show CartBloc;

class CartService {
  late final CartBloc cartBloc;

  CartService() {
    cartBloc = CartBloc();
  }
}
