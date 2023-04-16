import 'dart:convert' show json;

import 'package:equatable/equatable.dart' show Equatable;
import 'package:hive/hive.dart'
    show HiveField, HiveType, BinaryReader, TypeAdapter, BinaryWriter;

import '../../config/utils/app_strings.dart';

part 'menu.g.dart';

class Menu extends Equatable {
  final String category;
  final List<Item> items;

  const Menu({
    this.category = '',
    this.items = const [],
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': category,
      'items': items.map((x) => x.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      category: json['category'] as String,
      items: List<Item>.from(
        (json['items']).map<Item>(
          (x) => Item.fromJson(x),
        ),
      ),
    );
  }

  const Menu.empty()
      : category = '',
        items = const [];

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

  double itemPrice(Item item) {
    if (item.discount == 0) return item.price;
    final newPrice = _calcPrice(item.discount, item.price);
    return newPrice;
  }

  String discountPriceString(item) =>
      '${itemPrice(item).toStringAsFixed(2)}$currency';

  double _calcPrice(double itemDiscount, double itemPrice) {
    if (itemDiscount == 0) return itemPrice;

    assert(itemDiscount <= 100);

    if (itemDiscount > 100) return 0;

    final double discount = itemPrice * (itemDiscount / 100);
    final double discountPrice = itemPrice - discount;

    return discountPrice;
  }
}

@HiveType(typeId: 0)
class Item extends Equatable {
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
  const Item({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.discount,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'price': price,
      'discount': discount,
    };
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'],
      description: json['description'],
      imageUrl: json['image_url'],
      price: json['price'],
      discount: json['discount'],
    );
  }

  String get priceString => '${price.toStringAsFixed(2)}$currency';

  @override
  List<Object?> get props => [
        name,
        description,
        price,
        imageUrl,
        discount,
      ];
}
