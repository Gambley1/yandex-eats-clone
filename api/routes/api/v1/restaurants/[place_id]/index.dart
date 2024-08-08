import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:stormberry/stormberry.dart';
import 'package:yandex_food_api/api.dart';

Future<Response> onRequest(RequestContext context, String placeId) async {
  return switch (context.request.method) {
    HttpMethod.get => await _onGetRequest(context, placeId),
    HttpMethod.post => await _onPostRequest(context, placeId),
    HttpMethod.put => await _onPutRequest(context, placeId),
    HttpMethod.delete => await _onDeleteRequest(context, placeId),
    _ => Response().methodNotAllowed(),
  };
}

Future<Response> _onGetRequest(RequestContext context, String placeId) async {
  final db = await context.futureRead<Connection>();

  final lat = context.query('lat').doubleTryParse();
  final lng = context.query('lng').doubleTryParse();

  final restaurantView = await db.dbrestaurants.query(
    const FindRestaurantById(),
    QueryParams(
      values: {
        'place_id': placeId,
        if (lat != null) 'lat': lat,
        if (lng != null) 'lng': lng,
      },
    ),
  );
  if (restaurantView == null) return Response().notFound();

  final restaurant = Restaurant.fromView(
    restaurantView,
    userLocation:
        lat == null || lng == null ? null : Location(lat: lat, lng: lng),
  );
  return Response.json(body: {'restaurant': restaurant});
}

Future<Response> _onPostRequest(RequestContext context, String placeId) async {
  final name = context.query('name');
  final tags = context.query('tags');
  final imageUrl = context.query('image_url');
  final rating = context.query('rating').doubleTryParse();
  final userRatingsTotal = context.query('user_ratings_total').intParse();
  final priceLevel = context.query('price_level').intParse();
  final latitude = context.query('latitude').doubleTryParse();
  final longitude = context.query('longitude').doubleTryParse();

  final db = await context.futureRead<Connection>();

  final badRequest = name == null ||
      tags == null ||
      imageUrl == null ||
      rating == null ||
      latitude == null ||
      longitude == null;
  if (badRequest) return Response().badRequest();

  final insert = DBRestaurantInsertRequest(
    placeId: placeId,
    name: name,
    businessStatus: 'Restaurant',
    tags: (jsonDecode(tags) as List<dynamic>).cast<String>(),
    imageUrl: imageUrl,
    rating: rating,
    userRatingsTotal: userRatingsTotal,
    priceLevel: priceLevel,
    openNow: true,
    popular: false,
    latitude: latitude,
    longitude: longitude,
  );
  await db.dbrestaurants.insertOne(insert);
  return Response(statusCode: HttpStatus.created);
}

Future<Response> _onPutRequest(RequestContext context, String placeId) async {
  final name = context.query('name');
  final tags = context.query('tags');
  final imageUrl = context.query('image_url');
  final rating = context.query('rating').doubleTryParse();
  final userRatingsTotal = context.query('user_ratings_total').intTryParse();
  final latitude = context.query('latitude').doubleTryParse();
  final longitude = context.query('longitude').doubleTryParse();

  final db = await context.futureRead<Connection>();

  final update = DBRestaurantUpdateRequest(
    placeId: placeId,
    name: name,
    businessStatus: 'Restaurant',
    tags:
        tags != null ? (jsonDecode(tags) as List<dynamic>).cast<String>() : [],
    imageUrl: imageUrl,
    rating: rating,
    userRatingsTotal: userRatingsTotal,
    openNow: true,
    popular: false,
    latitude: latitude,
    longitude: longitude,
  );
  await db.dbrestaurants.updateOne(update);
  return Response(statusCode: HttpStatus.created);
}

Future<Response> _onDeleteRequest(
  RequestContext context,
  String placeId,
) async {
  final db = await context.futureRead<Connection>();

  await db.dbrestaurants.deleteOne(placeId);
  return Response(statusCode: HttpStatus.created);
}
