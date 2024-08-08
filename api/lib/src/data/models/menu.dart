import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:yandex_food_api/api.dart';

part 'menu.g.dart';

@JsonSerializable()
class Menu extends Equatable {
  const Menu({
    required this.category,
    required this.items,
  });

  factory Menu.fromView(DbmenuView view) => Menu(
        category: view.category,
        items: view.items.map(MenuItem.fromView).toList(),
      );

  factory Menu.fromJson(Map<String, dynamic> map) => _$MenuFromJson(map);

  final String category;
  final List<MenuItem> items;

  Menu copyWith({
    String? category,
    List<MenuItem>? items,
  }) {
    return Menu(
      category: category ?? this.category,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => <Object?>[category, items];

  Map<String, dynamic> toJson() => _$MenuToJson(this);
}
