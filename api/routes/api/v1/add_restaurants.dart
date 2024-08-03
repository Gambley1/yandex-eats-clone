import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:stormberry/stormberry.dart';
import 'package:yandex_food_api/api.dart';

Future<Response> onRequest(RequestContext context) async {
  final db = await context.futureRead<Connection>();

  await db.dbrestaurants
      .insertMany(DBFakeRestaurantsInsert.getRestaurantToInsert);

  return Response(statusCode: HttpStatus.created);
}
