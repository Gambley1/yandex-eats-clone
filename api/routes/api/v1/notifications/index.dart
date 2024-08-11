import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:intl/intl.dart';
import 'package:stormberry/stormberry.dart' hide Notification;
import 'package:yandex_food_api/api.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.post) return _onPostRequest(context);
  if (context.request.method == HttpMethod.get) return _onGetRequest(context);

  return Response().methodNotAllowed();
}

Future<Response> _onPostRequest(RequestContext context) async {
  final user = context.read<RequestUser>();
  if (user.isAnonymous) return Response().badRequest();

  final body = await context.safeJson();
  if (body == null) return Response().badRequest();

  final db = await context.futureRead<Connection>();

  final message = body['message'] as String?;
  if (message == null) return Response().badRequest();

  final now = DateTime.now();
  final formattedDate = DateFormat('dd MMMM HH:mm', 'en_US').format(now);

  final insert = DBNotificationInsertRequest(
    userId: user.id,
    message: message,
    date: formattedDate,
    isImportant: true,
  );

  await db.dbnotifications.insertOne(insert);

  return Response(statusCode: HttpStatus.created);
}

Future<Response> _onGetRequest(RequestContext context) async {
  final user = context.read<RequestUser>();
  if (user.isAnonymous) return Response().badRequest();

  final db = await context.futureRead<Connection>();

  final notificationsView = await db.dbnotifications.query(
    const FindUserNotifications(),
    QueryParams(values: {'user_id': user.id}),
  );

  final notifications = notificationsView.map(Notification.fromView).toList();
  return Response.json(body: {'notifications': notifications});
}
