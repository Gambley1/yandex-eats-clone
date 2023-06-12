import 'package:papa_burger/src/restaurant.dart' show CartBloc;

class CartService {
  CartService() {
    cartBloc = CartBloc();
  }
  late final CartBloc cartBloc;
}
