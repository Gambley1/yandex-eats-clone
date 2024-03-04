import 'package:papa_burger/src/config/dotenv.dart';
import 'package:web_socket_client/web_socket_client.dart';

class UserNotificationsRepository {
  UserNotificationsRepository();

  final WebSocket _ws = WebSocket(
    Uri.parse(DotEnvConfig.webSocketUserNotifications),
  );

  Stream<String> notifications() => _ws.messages.cast<String>();

  Stream<ConnectionState> connection() => _ws.connection;

  void close() => _ws.close();
}
