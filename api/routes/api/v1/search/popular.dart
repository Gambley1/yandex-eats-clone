import 'package:dart_frog/dart_frog.dart';
import 'package:stormberry/stormberry.dart';
import 'package:yandex_food_api/api.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response().methodNotAllowed();
  }

  final body = await context.safeJson();
  var tags = <String>[];
  if (body != null) {
    tags = (body['tags'] as List).cast<String>();
  }

  final lat = context.query('lat').doubleTryParse();
  final lng = context.query('lng').doubleTryParse();

  if (lat == null || lng == null) return Response().badRequest();

  final limit = context.query('limit').intTryParse();
  final offset = context.query('offset').intTryParse();

  final db = await context.futureRead<Connection>();

  List<DbrestaurantView> restaurantsView;
  if (tags.isNotEmpty) {
    restaurantsView = await db.dbrestaurants.query(
      const GetPopularRestaurantsByTags(),
      QueryParams(
        limit: limit,
        offset: offset,
        values: {'tags': tags, 'lat': lat, 'lng': lng},
      ),
    );
  } else {
    restaurantsView = await db.dbrestaurants.query(
      const GetPopularRestaurantsByLocation(),
      QueryParams(
        limit: limit,
        offset: offset,
        values: {'lat': lat, 'lng': lng},
      ),
    );
  }

  final userLocation = Location(lat: lat, lng: lng);
  final restaurants = restaurantsView
      .map((e) => Restaurant.fromView(e, userLocation: userLocation))
      .toList();

  return Response.json(body: {'restaurants': restaurants});
}
