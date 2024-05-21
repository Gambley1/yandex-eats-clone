import 'package:web_socket_client/web_socket_client.dart';

class NotificationsRepository {
  NotificationsRepository({WebSocket? socket})
      : _ws = socket ??
            WebSocket(
              // Uri.parse(DotEnvConfig.webSocketNotification),
              Uri.parse('uri'),
            );

  final WebSocket _ws;

  Stream<String> notifications() => _ws.messages.cast<String>();

  Stream<ConnectionState> connection() => _ws.connection;

  void close() => _ws.close();
}
