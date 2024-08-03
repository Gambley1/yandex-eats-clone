import 'package:stormberry/stormberry.dart';

part 'db_order_menu_item.schema.dart';

/// PostgreSQL DB Order Menu Items
@Model(tableName: 'Order menu items')
abstract class DBOrderMenuItem {
  /// Associated order menu items id identifier
  @PrimaryKey()
  @AutoIncrement()
  int get id;

  /// Associated order menu items item's name
  String get name;

  /// Assosisated order menu items item's quanityt
  int get quantity;

  /// Associated order menu items item's price
  double get price;

  /// Associated order menu items item's image url
  String get imageUrl;
}
