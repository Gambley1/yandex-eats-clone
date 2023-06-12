import 'package:papa_burger/src/config/dotenv.dart';
import 'package:web_socket_client/web_socket_client.dart';

class NotificationRepository {
  NotificationRepository({WebSocket? socket})
      : _ws = socket ??
            WebSocket(
              Uri.parse(DotEnvConfig.webSocketNotification),
            );

  final WebSocket _ws;

  Stream<String> notifications() => _ws.messages.cast<String>();

  Stream<ConnectionState> connection() => _ws.connection;

  void close() => _ws.close();
}
