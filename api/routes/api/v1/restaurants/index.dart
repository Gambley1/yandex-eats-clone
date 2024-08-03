import 'package:dart_frog/dart_frog.dart';
import 'package:stormberry/stormberry.dart';
import 'package:yandex_food_api/api.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response().methodNotAllowed();
  }

  final lat = context.query('lat').doubleTryParse();
  final lng = context.query('lng').doubleTryParse();

  if (lat == null || lng == null) return Response().badRequest();

  final limit = context.query('limit').intTryParse();
  final offset = context.query('offset').intTryParse();

  final db = await context.futureRead<Connection>();

  final restaurantsView = await db.dbrestaurants.query(
    const GetRestaurantsByLocation(),
    QueryParams(
      limit: limit,
      offset: offset,
      values: {'lat': lat, 'lng': lng},
    ),
  );

  final userLocation = Location(lat: lat, lng: lng);
  final restaurants = restaurantsView
      .map((e) => Restaurant.fromView(e, userLocation: userLocation))
      .toList();

  return Response.json(body: {'restaurants': restaurants});
}
