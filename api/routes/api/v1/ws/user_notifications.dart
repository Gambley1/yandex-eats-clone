import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:stormberry/stormberry.dart';
import 'package:yandex_food_api/api.dart';

final clients = <WebSocketChannel>[];

Future<Response> onRequest(RequestContext context) async {
  final handler = webSocketHandler((channel, protocol) async {
    final db = await context.futureRead<Connection>();

    await db.execute('LISTEN user_notification_table_changed');

    clients.add(channel);
    print('Active clients: ${clients.length}');

    void close() {
      clients.remove(channel);
      channel.sink.close();
      print('After close Active clients: ${clients.length}');
    }

    db.channels.all.listen(
      (notification) {
        final connectionChannel = notification.channel.toConnectionChannel;

        if (connectionChannel ==
            ConnectionChannel.userNotificationTableChanged) {
          final payload = notification.payload;
          final userNotification = jsonDecode(payload) as Map<String, dynamic>;
          final message = userNotification['message'] as String;
          final userUid = userNotification['user_uid'] as String;

          channel.sink.add(jsonEncode([message, userUid]));
        }
      },
      onDone: close,
      onError: (_) => close(),
      cancelOnError: true,
    );

    channel.stream.listen(
      (message) {
        if (message == '__disconnect__') close();
      },
      onDone: close,
      onError: (_) => close(),
      cancelOnError: true,
    );
  });
  return handler(context);
}
