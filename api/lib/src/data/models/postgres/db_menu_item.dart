import 'package:stormberry/stormberry.dart';

part 'db_menu_item.schema.dart';

/// PostgreSQL DB Menu Item model
@Model(tableName: 'MenuItem')
abstract class DBMenuItem {
  /// Id primary, auto incrementing key, using as an identifier of menu
  @PrimaryKey()
  @AutoIncrement()
  int get id;

  /// Menu Item name field
  String get name;

  /// Menu Item description field
  String get description;

  /// Menu Item image url field
  String get imageUrl;

  /// Menu Item price field
  double get price;

  /// Menu Item discount field
  double get discount;
}
