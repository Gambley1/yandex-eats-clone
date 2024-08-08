import 'package:stormberry/stormberry.dart';
import 'package:yandex_food_api/api.dart';

part 'db_restaurant.schema.dart';

/// PostgreSQL DB Restaurant model
@Model(tableName: 'Restaurant')
abstract class DBRestaurant {
  /// Primary place id key, identifier for DB restaurant model
  @PrimaryKey()
  String get placeId;

  /// Restaurant name field
  String get name;

  /// Restaurant businessStatus field
  String get businessStatus;

  /// Restaurant tags field
  List<String> get tags;

  /// Restaurant menu field
  List<DBMenu>? get menu;

  /// Restaurant imageUrl field
  String get imageUrl;

  /// Restaurant rating field
  double get rating;

  /// Restaurant userRatingsTotal field
  int get userRatingsTotal;

  /// The price level of the restaurant, within the range of 0 to 3.
  int get priceLevel;

  /// Restaurant openNow field
  bool get openNow;

  /// Restaurant popular field
  bool get popular;

  /// Restaurant latitude field
  double get latitude;

  /// Restaurant longitude field
  double get longitude;
}
