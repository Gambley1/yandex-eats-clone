import 'package:stormberry/stormberry.dart';

part 'db_notification.schema.dart';

/// {@macro db_notification}
@Model(tableName: 'Notification')
abstract class DBNotification {
  /// Unique identifier of notification.
  @AutoIncrement()
  @PrimaryKey()
  int get id;

  String get userId;

  /// Message text of notification.
  String get message;

  /// Date of notification.
  String get date;

  /// Whether notification is important.
  bool get isImportant;
}
