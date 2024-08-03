// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:yandex_food_api/src/data/models/postgres/postgres.dart';

/// {@template notification}
/// Notification class
/// {@endtemplate}
class Notification {
  /// {@macro notification}
  const Notification({
    required this.id,
    required this.message,
    required this.date,
    required this.isImportant,
  });

  /// Associated notification id identifier
  final int id;

  /// Associated notification message
  final String message;

  ///  Associated notification date
  final String date;

  /// Associated notification is important identifier
  final bool? isImportant;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'message': message,
        'date': date,
        'is_important': isImportant,
      };

  factory Notification.fromJson(Map<String, dynamic> map) {
    return Notification(
      id: map['id'] as int,
      message: map['message'] as String,
      date: map['date'] as String,
      isImportant:
          map['is_important'] != null ? map['is_important'] as bool : null,
    );
  }

  factory Notification.fromView(DbnotificationView notification) {
    return Notification(
      id: notification.id,
      message: notification.message,
      date: notification.date,
      isImportant: notification.isImportant,
    );
  }
}
