import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:stormberry/stormberry.dart' hide Notification;
import 'package:yandex_food_api/api.dart';

final clients = <WebSocketChannel>[];

Future<Response> onRequest(RequestContext context) async {
  final handler = webSocketHandler(
    (channel, protocol) async {
      final db = await context.futureRead<Connection>();

      await db.execute('LISTEN notification_table_changed');

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

          if (connectionChannel == ConnectionChannel.notificationTableChanged) {
            final serverNotification = Notification.fromJson(
              jsonDecode(notification.payload) as Map<String, dynamic>,
            );

            final message = serverNotification.message;
            channel.sink.add(message);
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
    },
  );

  return handler(context);
}
