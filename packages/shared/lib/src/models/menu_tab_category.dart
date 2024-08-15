import 'package:yandex_food_api/client.dart';

class MenuTabCategory {
  const MenuTabCategory({
    required this.menuCategory,
    required this.selected,
    required this.offsetFrom,
    required this.offsetTo,
  });
  
  final Menu menuCategory;
  final bool selected;
  final double offsetFrom;
  final double offsetTo;

  MenuTabCategory copyWith({
    Menu? menuCategory,
    bool? selected,
    double? offsetFrom,
    double? offsetTo,
  }) {
    return MenuTabCategory(
      menuCategory: menuCategory ?? this.menuCategory,
      selected: selected ?? this.selected,
      offsetFrom: offsetFrom ?? this.offsetFrom,
      offsetTo: offsetTo ?? this.offsetTo,
    );
  }
}
