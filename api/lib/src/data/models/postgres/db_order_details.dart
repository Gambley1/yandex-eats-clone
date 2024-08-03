import 'package:stormberry/stormberry.dart';
import 'package:yandex_food_api/api.dart';

part 'db_order_details.schema.dart';

/// PostgreSQL DB User Order Details
@Model(tableName: 'Order details')
abstract class DBOrderDetails {
  /// Associated user order details id identifier
  @PrimaryKey()
  String get id;

  /// Associated user order details user id
  String get userId;

  /// Associated user order details status
  String get status;

  /// Associated user order details date
  String get date;

  /// Associated user order details restaurant place id
  String get restaurantPlaceId;

  /// Associated user order details restaurant name
  String get restaurantName;

  /// Associated user order details order address
  String get orderAddress;

  /// Associated user order details order menu items
  List<DBOrderMenuItem> get orderMenuItems;

  /// Assosisated user order details total order sum
  double get totalOrderSum;

  /// Associated user order details order deilvery fee
  double get orderDeliveryFee;
}
