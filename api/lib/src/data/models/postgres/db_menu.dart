import 'package:stormberry/stormberry.dart';
import 'package:yandex_food_api/api.dart';

part 'db_menu.schema.dart';

/// PostgreSQL DB Menu model
@Model(tableName: 'Menu')
abstract class DBMenu {
  /// Primary, auto incrementing key identifier for DB Menu model
  @PrimaryKey()
  @AutoIncrement()
  int get id;

  /// Menu category field, identifier for items
  String get category;

  /// Menu items field, storing all items of each section by each category
  List<DBMenuItem> get items;
}
