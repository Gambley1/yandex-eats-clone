import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:shared/shared.dart';

part 'menu.g.dart';

class Menu extends Equatable {
  const Menu({
    this.category = '',
    this.items = const [],
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      category: json['category'] as String,
      items: List<dynamic>.from(
        json['items'] as List,
      ).map((e) => Item.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  const Menu.empty()
      : category = '',
        items = const [];

  final String category;
  final List<Item> items;

  Map<String, dynamic> toJson() => {
        'name': category,
        'items': items.map((x) => x.toJson()).toList(),
      };

  Menu copyWith({
    String? category,
    List<Item>? items,
  }) {
    return Menu(
      category: category ?? this.category,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => <Object?>[category, items];

  static String priceWithDiscountToString(Item item) =>
      _calculateItemPriceWithDiscount(item).currencyFormat();

  static String priceWithDiscountWithQuantityToString(
          Item item, int quantity,) =>
      (_calculateItemPriceWithDiscount(item) * quantity).currencyFormat();

  static double _calculateItemPriceWithDiscount(Item item) {
    final itemPrice = item.price;
    final itemDiscount = item.discount;
    if (itemDiscount == 0) return itemPrice;

    assert(itemDiscount <= 100, "Item's discount can't be more than 100%.");

    if (itemDiscount > 100) return 0;

    final discount = itemPrice * (itemDiscount / 100);
    final discountPrice = itemPrice - discount;

    return discountPrice;
  }
}

@HiveType(typeId: 0)
class Item extends Equatable {
  const Item({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.discount,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['image_url'] as String,
      price: json['price'] as double,
      discount: json['discount'] as double,
    );
  }

  @HiveField(0)
  final String name;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final String imageUrl;

  @HiveField(3)
  final double price;

  @HiveField(20)
  final double discount;

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'image_url': imageUrl,
        'price': price,
        'discount': discount,
      };

  String get priceToString => price.currencyFormat();

  String priceWithQuantityToString(int quantity) =>
      (price * quantity).currencyFormat();

  @override
  List<Object?> get props => [
        name,
        description,
        price,
        imageUrl,
        discount,
      ];
}
