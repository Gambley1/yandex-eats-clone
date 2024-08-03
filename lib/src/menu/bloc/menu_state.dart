// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'menu_bloc.dart';

enum MenuStatus { initial, loading, populated, failure }

class MenuState extends Equatable {
  const MenuState({
    required this.status,
    required this.menus,
    required this.restaurant,
  });

  const MenuState.initial()
      : this(
          status: MenuStatus.initial,
          menus: const [],
          restaurant: null,
        );

  final MenuStatus status;
  final List<Menu> menus;
  final Restaurant? restaurant;

  @override
  List<Object?> get props => [status, menus, restaurant];

  MenuState copyWith({
    MenuStatus? status,
    List<Menu>? menus,
    Restaurant? restaurant,
  }) {
    return MenuState(
      status: status ?? this.status,
      menus: menus ?? this.menus,
      restaurant: restaurant ?? this.restaurant,
    );
  }
}
