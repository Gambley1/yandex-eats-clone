import 'package:dart_frog/dart_frog.dart';
import 'package:stormberry/stormberry.dart';
import 'package:yandex_food_api/api.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response().methodNotAllowed();
  }

  final lat = context.query('lat').doubleParse();
  final lng = context.query('lng').doubleParse();

  final body = await context.safeJson();
  if (body == null) return Response().badRequest();
  final tags = (body['tags'] as List).cast<String>();

  final db = await context.futureRead<Connection>();

  final restaurantsView = await db.dbrestaurants.query(
    const GetRestaurantsByTags(),
    QueryParams(
      values: {'tags': tags, 'lat': lat, 'lng': lng},
    ),
  );

  final userLocation = Location(lat: lat, lng: lng);
  final restaurants = restaurantsView
      .map((e) => Restaurant.fromView(e, userLocation: userLocation))
      .toList();

  return Response.json(body: {'restaurants': restaurants});
}
