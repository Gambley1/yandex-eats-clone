import 'package:stormberry/stormberry.dart';

part 'db_credit_card.schema.dart';

/// PostgreSQL DB Credit Card Model
@Model(tableName: 'Credit card')
abstract class DBCreditCard {
  @PrimaryKey()
  @AutoIncrement()

  /// User credit card id identifier
  int get id;

  /// User credit card number
  String get number;

  /// User credit card expiry date
  String get expiryDate;

  /// User credit card cvv code
  String get cvv;

  /// The user id that owns the credit card.
  String get userId;
}
