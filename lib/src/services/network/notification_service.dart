import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:papa_burger/src/services/repositories/notifications/notifications_repository.dart';
import 'package:papa_burger/src/services/repositories/notifications/user_notifications_repository.dart';
import 'package:papa_burger/src/services/storage/storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared/shared.dart';

final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
final _userNotificationRepository = UserNotificationsRepository();

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
    String title = 'Papa Burger',
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
      body: 'Your order №$orderId has been successfully formed! '
          ' It will be delivered by $deliveryTime.',
    );

    _userNotificationRepository.notifications().listen((value) async {
      if (value.isNotEmpty) {
        await cancelOngoingNotification(id);
      }
    });
  }

  static Future<void> cancelOngoingNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  static Future<void> cancelAllNotifications() async =>
      _flutterLocalNotificationsPlugin.cancelAll();

  static Future<void> initNotifications() async {
    await _init();
    final notificationRepository = NotificationsRepository();

    notificationRepository.notifications().listen((message) {
      logI((messageChanged: message));
      showBigTextNotification(body: message);
    });

    _userNotificationRepository.notifications().listen((message) {
      final list = jsonDecode(message) as List;
      final userUid = list[1] as String;
      final uid = LocalStorage().getToken;
      if (uid != userUid) {
        return;
      } else {
        final message$ = list[0] as String;
        logI('User notification message: ${message$}');
        showBigTextNotification(body: message$);
      }
    });
  }

  static Future<void> requestNotificationPermission() async {
    final permission = await Permission.notification.status;
    if (permission == PermissionStatus.denied) {
      await Permission.notification.request();
    }
  }
}
