import 'package:json_annotation/json_annotation.dart';
import 'package:yandex_food_api/src/data/models/postgres/postgres.dart';

part 'notification.g.dart';

/// {@template notification}
/// Notification class
/// {@endtemplate}
@JsonSerializable()
class Notification {
  /// {@macro notification}
  const Notification({
    required this.id,
    required this.message,
    required this.date,
    required this.isImportant,
  });

  factory Notification.fromJson(Map<String, dynamic> map) =>
      _$NotificationFromJson(map);

  factory Notification.fromView(DbnotificationView notification) {
    return Notification(
      id: notification.id,
      message: notification.message,
      date: notification.date,
      isImportant: notification.isImportant,
    );
  }

  /// Associated notification id identifier
  final int id;

  /// Associated notification message
  final String message;

  ///  Associated notification date
  final String date;

  /// Associated notification is important identifier
  final bool? isImportant;

  Map<String, dynamic> toJson() => _$NotificationToJson(this);
}
