import 'package:flutter_dotenv/flutter_dotenv.dart';

class DotEnvConfig {
  DotEnvConfig();

  static final googleApiKey = dotenv.get('GOOGLE_API_KEY');

  static final publishStripeKey = dotenv.get('STRIPE_PUBLISH_KEY');

  static final secretStripeKey = dotenv.get('STRIPE_SECRET_KEY');

  static final webSocketNotification =
      dotenv.get('WEB_SOCKET_NOTIFICATION_URL');

  static final webSocketUserNotifications =
      dotenv.get('WEB_SOCKET_USER_NOTIFICATION_URL');

  // static final webSocketOrdersChangedNotification =
  //     dotenv.get('WEB_SOCKET_ORDERS_CHANGED_NOTIFICATION_URL');

  static final webSocketOrderStatusChanged =
      dotenv.get('WEB_SOCKET_USER_ORDER_STATUS_NOTIFICATION_URL');

  // static String webSocketOrderStatusChanged(String uid) =>
  //     '${webSocketOrderStatusChanged$}?uid=$uid';
}
