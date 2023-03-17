import 'dart:convert' show json;

import 'package:equatable/equatable.dart' show Equatable;
import 'package:hive/hive.dart'
    show HiveField, HiveType, BinaryReader, TypeAdapter, BinaryWriter;
import 'package:flutter/foundation.dart' show immutable;

part 'menu.g.dart';

class Menu extends Equatable {
  final String category;
  final List<Item> items;

  const Menu({
    required this.category,
    required this.items,
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
}

@immutable
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
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      price: json['price'] ?? 0,
      discount: json['discount'] ?? 0.0,
    );
  }

  String get priceString => '${price.toStringAsFixed(2)}\$';

  @override
  List<Object?> get props => [
        name,
        description,
        price,
        imageUrl,
        discount,
      ];
}
