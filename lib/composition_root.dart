import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:papa_burger/src/restaurant.dart'
    show ItemAdapter, LocalStorage, LocalStorageRepository, MyThemeData;
import 'package:papa_burger/src/services/network/notification_service.dart';

class CompositionRoot {
  static Future<void> configureApp() async {
    await dotenv.load();
    // Stripe.publishableKey = DotEnvConfig.publishStripeKey;
    // Stripe.merchantIdentifier = 'MerchantIdentifier';
    // Stripe.urlScheme = 'flutterstripe';
    // await Stripe.instance.applySettings();
    await NotificationService.initNotifications();
    await NotificationService.requestNotificationPermission();
    await LocalStorage.instance.init();
    await Hive.initFlutter().then(
      (_) => Hive.registerAdapter(
        ItemAdapter(),
      ),
    );
    await LocalStorageRepository.initBoxes();
    MyThemeData.setGlobalThemeSettings();
  }
}
