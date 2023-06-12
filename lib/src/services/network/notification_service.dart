import 'package:faker/faker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:papa_burger/src/config/logger.dart';
import 'package:papa_burger/src/services/repositories/notification/notification_repository.dart';
import 'package:permission_handler/permission_handler.dart';

final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

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
    required String title,
    required String body,
    int? id,
    String? payload,
  }) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'notifications',
      'Main notifications',
      // sound: RawResourceAndroidNotificationSound('notification'),
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
