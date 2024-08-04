import 'package:equatable/equatable.dart';
import 'package:yandex_food_api/client.dart';

class MenuProps extends Equatable {
  const MenuProps({required this.restaurant});

  final Restaurant restaurant;

  @override
  List<Object> get props => [restaurant];
}
