import 'package:papa_burger/src/restaurant.dart';

class CartService {
  // late final CartBloc cartBloc;

  // static final CartService _instance = CartService._privateConstructor();

  // factory CartService() => _instance;

  // CartService._privateConstructor() {
  //   cartBloc = CartBloc();
  // }

  late final CartBloc cartBloc;

  CartService() {
    cartBloc = CartBloc();
  }
}
