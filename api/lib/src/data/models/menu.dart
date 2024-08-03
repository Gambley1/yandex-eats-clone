// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';
import 'package:yandex_food_api/api.dart';

class Menu extends Equatable {
  const Menu({
    required this.category,
    required this.items,
  });

  factory Menu.fromView(DbmenuView view) => Menu(
        category: view.category,
        items: view.items.map(MenuItem.fromView).toList(),
      );

  factory Menu.fromJson(Map<String, dynamic> map) {
    return Menu(
      category: map['category'] as String,
      items: List<MenuItem>.from(
        (map['items'] as List).map<MenuItem>(
          (x) => MenuItem.fromJson(x as Map<String, dynamic>),
        ),
      ),
    );
  }

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

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'category': category,
      'items': items.map((x) => x.toJson()).toList(),
    };
  }
}
