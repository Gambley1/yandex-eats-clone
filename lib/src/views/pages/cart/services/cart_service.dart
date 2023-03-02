import 'package:papa_burger/src/restaurant.dart';

class CartService {
  static final CartService _instance = CartService._privateConstructor();

  factory CartService() => _instance;

  CartService._privateConstructor();

  final CartBloc cartBloc = CartBloc();
}
