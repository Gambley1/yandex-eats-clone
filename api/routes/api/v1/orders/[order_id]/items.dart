import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:stormberry/stormberry.dart';
import 'package:yandex_food_api/api.dart';

Future<Response> onRequest(RequestContext context, String orderId) async {
  return switch (context.request.method) {
    HttpMethod.post => await _onPostRequested(context, orderId),
    HttpMethod.delete => await _onDeleteRequest(context, orderId),
    _ => Response().methodNotAllowed(),
  };
}

Future<Response> _onPostRequested(
  RequestContext context,
  String orderId,
) async {
  final body = await context.safeJson();
  if (body == null) return Response().badRequest();

  final name = body['name'] as String?;
  final quantity = (body['quantity'] as String?).intTryParse();
  final price = (body['price'] as String?).doubleTryParse();
  final imageUrl = body['image_url'] as String?;

  final db = await context.futureRead<Connection>();

  final badRequest =
      name == null || quantity == null || price == null || imageUrl == null;

  if (badRequest) {
    return Response().badRequest();
  }
  final insert = DBOrderMenuItemInsertRequest(
    orderDetailsId: orderId,
    name: name,
    quantity: quantity,
    price: price,
    imageUrl: imageUrl,
  );
  await db.dborderMenuItems.insertOne(insert);

  return Response(statusCode: HttpStatus.created);
}

Future<Response> _onDeleteRequest(
  RequestContext context,
  String orderId,
) async {
  final db = await context.futureRead<Connection>();

  final ids = await db.dborderMenuItems.query(
    const FindOrderMenuItemIds(),
    QueryParams(values: {'order_id': orderId}),
  );
  await db.dborderMenuItems.deleteMany(ids);
  return Response(statusCode: HttpStatus.created);
}
