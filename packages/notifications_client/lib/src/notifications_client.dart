// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

export 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// {@template notifications_exception}
/// Exceptions from notifications client.
/// {@endtemplate}
abstract class NotificationsException implements Exception {
  /// {@macro notifications_exception}
  const NotificationsException(this.error);

  /// The error which was caught.
  final Object error;
}

/// {@template initialize_flutter_local_notifications_plugin_failure}
/// Thrown when initializing flutter local notifications plugin fails.
/// {@endtemplate}
class InitializeFlutterLocalNotificationsPluginFailure
    extends NotificationsException {
  /// {@macro initialize_flutter_local_notifications_plugin_failure}
  const InitializeFlutterLocalNotificationsPluginFailure(super.error);
}

/// {@template show_text_notification_failure}
/// Thrown when showing text notification fails.
/// {@endtemplate}
class ShowTextNotificationFailure extends NotificationsException {
  /// {@macro show_text_notification_failure}
  const ShowTextNotificationFailure(super.error);
}

/// {@template cancel_notification_failure}
/// Thrown when canceling notification fails.
/// {@endtemplate}
class CancelNotificationFailure extends NotificationsException {
  /// {@macro cancel_notification_failure}
  const CancelNotificationFailure(super.error);
}

/// {@template cancel_all_notifications_failure}
/// Thrown when canceling notification fails.
/// {@endtemplate}
class CancelAllNotificationsFailure extends NotificationsException {
  /// {@macro cancel_all_notifications_failure}
  const CancelAllNotificationsFailure(super.error);
}

/// {@template notifications_client}
/// Flutter in-app local Notifications Client.
/// {@endtemplate}
class NotificationsClient {
  /// {@macro notifications_client}
  NotificationsClient([
    FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin,
  ]) : _flutterLocalNotificationsPlugin = flutterLocalNotificationsPlugin ??
            FlutterLocalNotificationsPlugin() {
    unawaited(_initializeFlutterLocalNotificationsPlugin());
  }

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  Future<void> _initializeFlutterLocalNotificationsPlugin() async {
    try {
      const android = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iOS = DarwinInitializationSettings();
      const initializationSettings = InitializationSettings(
        android: android,
        iOS: iOS,
      );
      await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        InitializeFlutterLocalNotificationsPluginFailure(error),
        stackTrace,
      );
    }
  }

  AndroidNotificationDetails _androidNotificationDetails({
    required String name,
    String id = 'notifications',
    Importance importance = Importance.max,
    Priority priority = Priority.high,
    bool isOngoing = false,
    bool autoCancel = true,
  }) {
    return AndroidNotificationDetails(
      id,
      name,
      importance: importance,
      priority: priority,
      ongoing: isOngoing,
      autoCancel: autoCancel,
    );
  }

  Future<int> showTextNotification({
    required String body,
    String? title,
    bool isOngoing = false,
    int? id,
    String? payload,
  }) async {
    try {
      final notification = NotificationDetails(
        android: _androidNotificationDetails(
          name: 'Main notifications',
          isOngoing: isOngoing,
        ),
        iOS: const DarwinNotificationDetails(),
      );
      final randomId = Random().nextInt(10000);
      await _flutterLocalNotificationsPlugin.show(
        id ?? randomId,
        title ?? 'Yandex Food',
        body,
        notification,
        payload: payload,
      );
      return id ?? randomId;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(ShowTextNotificationFailure(error), stackTrace);
    }
  }

  Future<void> cancelNotification(int id) async {
    try {
      await _flutterLocalNotificationsPlugin.cancel(id);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(CancelNotificationFailure(error), stackTrace);
    }
  }

  Future<void> cancelAllNotifications() async {
    try {
      await _flutterLocalNotificationsPlugin.cancelAll();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        CancelAllNotificationsFailure(error),
        stackTrace,
      );
    }
  }
}
