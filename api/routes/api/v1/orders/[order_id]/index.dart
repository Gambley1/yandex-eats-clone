import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:stormberry/stormberry.dart';
import 'package:yandex_food_api/api.dart';

Future<Response> onRequest(RequestContext context, String orderId) async {
  return switch (context.request.method) {
    HttpMethod.get => await _onGetRequest(context, orderId),
    HttpMethod.post => await _onPostRequest(context, orderId),
    HttpMethod.put => await _onPutRequest(context, orderId),
    HttpMethod.delete => await _onDeleteRequest(context, orderId),
    _ => Response().methodNotAllowed(),
  };
}

Future<Response> _onPostRequest(RequestContext context, String orderId) async {
  final user = context.read<RequestUser>();
  if (user.isAnonymous) return Response().badRequest();

  final body = await context.safeJson();
  if (body == null) return Response().badRequest();

  final date = body['created_at'] as String?;
  final restaurantPlaceId = body['restaurant_place_id'] as String?;
  final restaurantName = body['restaurant_name'] as String?;
  final orderAddress = body['address'] as String?;
  final totalOrderSum = (body['total_order_sum'] as String?).doubleTryParse();
  final deliveryFee = (body['delivery_fee'] as String?).doubleTryParse();
  final noParamters = date == null ||
      restaurantPlaceId == null ||
      restaurantName == null ||
      orderAddress == null ||
      totalOrderSum == null ||
      deliveryFee == null;

  if (noParamters) return Response().badRequest();

  final db = await context.futureRead<Connection>();

  final insert = DBOrderDetailsInsertRequest(
    id: orderId,
    status: OrderStatus.pending.name,
    date: date,
    restaurantPlaceId: restaurantPlaceId,
    restaurantName: restaurantName,
    orderAddress: orderAddress,
    totalOrderSum: totalOrderSum,
    orderDeliveryFee: deliveryFee,
    userId: user.id,
  );
  await db.dborderDetailses.insertOne(insert);
  return Response(statusCode: HttpStatus.created);
}

Future<Response> _onGetRequest(RequestContext context, String orderId) async {
  final db = await context.futureRead<Connection>();
  final user = context.read<RequestUser>();
  if (user.isAnonymous) return Response().badRequest();

  final orderView = (await db.dborderDetailses.queryDborderDetailses(
    QueryParams(
      where: 'id = @order_id AND user_id = @user_id',
      values: {
        'order_id': orderId,
        'user_id': user.id,
      },
      limit: 1,
    ),
  ))
      .firstOrNull;
  if (orderView == null) return Response.json(body: {'order': null});
  final order = Order.fromView(orderView);

  return Response.json(body: {'order': order.toJson()});
}

Future<Response> _onPutRequest(RequestContext context, String orderId) async {
  final user = context.read<RequestUser>();
  if (user.isAnonymous) return Response().badRequest();

  final body = await context.safeJson();
  if (body == null) return Response().badRequest();

  final status = body['status'] as String?;
  final date = body['created_at'] as String?;
  final restaurantPlaceId = body['restaurant_place_id'] as String?;
  final restaurantName = body['restaurant_name'] as String?;
  final orderAddress = body['address'] as String?;
  final totalOrderSum = (body['total_order_sum'] as String?).doubleTryParse();
  final deliveryFee = (body['delivery_fee'] as String?).doubleTryParse();
  final noParamters = status == null &&
      date == null &&
      restaurantPlaceId == null &&
      restaurantName == null &&
      orderAddress == null &&
      totalOrderSum == null &&
      deliveryFee == null;

  if (noParamters) return Response().badRequest();

  final db = await context.futureRead<Connection>();

  final update = DBOrderDetailsUpdateRequest(
    id: orderId,
    status: status,
    date: date,
    orderAddress: orderAddress,
    orderDeliveryFee: deliveryFee,
    restaurantName: restaurantName,
    restaurantPlaceId: restaurantPlaceId,
    totalOrderSum: totalOrderSum,
    userId: user.id,
  );
  await db.dborderDetailses.updateOne(update);
  return Response(statusCode: HttpStatus.created);
}

Future<Response> _onDeleteRequest(
  RequestContext context,
  String orderId,
) async {
  final user = context.read<RequestUser>();
  if (user.isAnonymous) return Response().badRequest();

  final db = await context.futureRead<Connection>();

  final order = (await db.dborderDetailses.queryDborderDetailses(
    QueryParams(
      where: 'id = @order_id AND user_id = @user_id',
      values: {
        'order_id': orderId,
        'user_id': user.id,
      },
      limit: 1,
    ),
  ))
      .firstOrNull;
  if (order == null) return Response().notFound();
  await db.dborderDetailses.deleteOne(order.id);

  return Response(statusCode: HttpStatus.created);
}
