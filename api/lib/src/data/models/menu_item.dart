import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:yandex_food_api/api.dart';

part 'menu_item.g.dart';

@JsonSerializable()
class MenuItem extends Equatable {
  const MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.discount,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) =>
      _$MenuItemFromJson(json);

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

  MenuItem copyWith({
    int? id,
    String? name,
    String? description,
    String? imageUrl,
    double? price,
    double? discount,
  }) {
    return MenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      discount: discount ?? this.discount,
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

  Map<String, dynamic> toJson() => _$MenuItemToJson(this);
}
