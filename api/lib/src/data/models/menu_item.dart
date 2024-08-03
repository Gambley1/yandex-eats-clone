// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';
import 'package:yandex_food_api/api.dart';

class MenuItem extends Equatable {
  const MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.discount,
    this.proccessing = false,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['image_url'] as String,
      price: json['price'] as double,
      discount: json['discount'] as double,
    );
  }

  factory MenuItem.fromView(DbmenuItemView view) {
    return MenuItem(
      id: view.id,
      name: view.name,
      description: view.description,
      imageUrl: view.imageUrl,
      price: view.price,
      discount: view.discount,
    );
  }

  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final double discount;
  final bool proccessing;

  MenuItem copyWith({
    int? id,
    String? name,
    String? description,
    String? imageUrl,
    double? price,
    double? discount,
    bool? proccessing,
  }) {
    return MenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      discount: discount ?? this.discount,
      proccessing: proccessing ?? this.proccessing,
    );
  }

  bool get hasDiscount => discount != 0;

  String get formattedPrice => price.currencyFormat();

  String formattedPriceWithQuantity(int quantity) =>
      (price * quantity).currencyFormat();

  String formattedPriceWithDiscount([int? quantity]) => quantity != null
      ? (priceWithDiscount * quantity).currencyFormat()
      : priceWithDiscount.currencyFormat();

  double get priceWithDiscount {
    if (!hasDiscount) return price;

    assert(discount <= 100, "Item's discount can't be more than 100%.");
    return price - (price * (discount / 100));
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        imageUrl,
        discount,
      ];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'price': price,
      'discount': discount,
    };
  }
}
