import 'package:equatable/equatable.dart';
import 'package:shared/shared.dart';

class MenuProps extends Equatable {
  const MenuProps({required this.restaurant, this.fromCart = false});

  final Restaurant restaurant;
  final bool fromCart;

  @override
  List<Object> get props => [restaurant, fromCart];
}
