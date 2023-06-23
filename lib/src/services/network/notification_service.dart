import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:papa_burger/src/restaurant.dart';
import 'package:papa_burger/src/services/repositories/notification/notification_repository.dart';
import 'package:papa_burger/src/services/repositories/notification/user_notification_repository.dart';
import 'package:permission_handler/permission_handler.dart';

final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
final _userNotificationRepository = UserNotificationRepository();
final _localStorage = LocalStorage.instance;

class NotificationService {
  static Future<void> _init() async {
    const androidInitialize =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOSInitialize = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: androidInitialize,
      iOS: iOSInitialize,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> showBigTextNotification({
    required String body,
    String? title,
    int? id,
    String? payload,
  }) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'notifications',
      'Main notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notification = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(),
    );
    final id = Faker().randomGenerator.integer(100000, min: 1);
    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notification,
      payload: payload,
    );
  }

  static Future<int> showOngoingNotification({
    required String title,
    required String body,
    int? id,
    String? payload,
  }) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'notifications',
      'Ongoing notifications',
      importance: Importance.max,
      priority: Priority.high,
      ongoing: true,
      autoCancel: false,
    );

    const notification = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(),
    );
    final id = Faker().randomGenerator.integer(100000, min: 1);
    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notification,
      payload: payload,
    );
    return id;
  }

  static Future<void> showOngoingOrderNotification(
    String deliveryTime,
    String orderId,
  ) async {
    final id = await showOngoingNotification(
      title: 'Papa Burger',
      body: 'Your order №$orderId has been successfuly formed! '
          ' It will be delivered by $deliveryTime.',
    );

    _userNotificationRepository.notifications().listen((value) async {
      if (value.isNotEmpty) {
        await cancelOngoinNotification(id);
      }
    });
  }

  static Future<void> cancelOngoinNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  static Future<void> cancelAllNotifications() async =>
      _flutterLocalNotificationsPlugin.cancelAll();

  static Future<void> initNotifications() async {
    await _init();
    final notificationRepository = NotificationRepository();

    notificationRepository.notifications().listen((message) {
      logger
        ..i('Notification repository message changed.')
        ..i('New message: $message');
      showBigTextNotification(
        title: 'Papa Burger',
        body: message,
      );
    });

    _userNotificationRepository.notifications().listen((message) {
      final list = jsonDecode(message) as List;
      final userUid = list[1] as String;
      final uid = _localStorage.getToken;
      if (uid != userUid) {
        return;
      } else {
        final message$ = list[0] as String;
        logger.i('User notification message: ${message$}');
        showBigTextNotification(body: message$);
      }
    });
  }

  static Future<void> requestNotificationPermission() async {
    final permission = await Permission.notification.status;
    if (permission == PermissionStatus.denied) {
      await Permission.notification.request();
      if (permission == PermissionStatus.granted) {
        logger.i('Notification permission granted.');
      }
    }
  }
}
