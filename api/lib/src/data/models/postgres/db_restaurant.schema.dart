// ignore_for_file: annotate_overrides

part of 'db_restaurant.dart';

extension DbRestaurantRepositories on Session {
  DBRestaurantRepository get dbrestaurants => DBRestaurantRepository._(this);
}

abstract class DBRestaurantRepository
    implements
        ModelRepository,
        ModelRepositoryInsert<DBRestaurantInsertRequest>,
        ModelRepositoryUpdate<DBRestaurantUpdateRequest>,
        ModelRepositoryDelete<String> {
  factory DBRestaurantRepository._(Session db) = _DBRestaurantRepository;

  Future<DbrestaurantView?> queryDbrestaurant(String placeId);
  Future<List<DbrestaurantView>> queryDbrestaurants([QueryParams? params]);
}

class _DBRestaurantRepository extends BaseRepository
    with
        RepositoryInsertMixin<DBRestaurantInsertRequest>,
        RepositoryUpdateMixin<DBRestaurantUpdateRequest>,
        RepositoryDeleteMixin<String>
    implements DBRestaurantRepository {
  _DBRestaurantRepository(super.db) : super(tableName: 'Restaurant', keyName: 'place_id');

  @override
  Future<DbrestaurantView?> queryDbrestaurant(String placeId) {
    return queryOne(placeId, DbrestaurantViewQueryable());
  }

  @override
  Future<List<DbrestaurantView>> queryDbrestaurants([QueryParams? params]) {
    return queryMany(DbrestaurantViewQueryable(), params);
  }

  @override
  Future<void> insert(List<DBRestaurantInsertRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.execute(
      Sql.named(
          'INSERT INTO "Restaurant" ( "place_id", "name", "latitude", "longitude", "business_status", "tags", "image_url", "rating", "user_ratings_total", "open_now", "popular" )\n'
          'VALUES ${requests.map((r) => '( ${values.add(r.placeId)}:text, ${values.add(r.name)}:text, ${values.add(r.latitude)}:float8, ${values.add(r.longitude)}:float8, ${values.add(r.businessStatus)}:text, ${values.add(r.tags)}:_text, ${values.add(r.imageUrl)}:text, ${values.add(r.rating)}:float8, ${values.add(r.userRatingsTotal)}:int8, ${values.add(r.openNow)}:boolean, ${values.add(r.popular)}:boolean )').join(', ')}\n'),
      parameters: values.values,
    );
  }

  @override
  Future<void> update(List<DBRestaurantUpdateRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.execute(
      Sql.named('UPDATE "Restaurant"\n'
          'SET "name" = COALESCE(UPDATED."name", "Restaurant"."name"), "latitude" = COALESCE(UPDATED."latitude", "Restaurant"."latitude"), "longitude" = COALESCE(UPDATED."longitude", "Restaurant"."longitude"), "business_status" = COALESCE(UPDATED."business_status", "Restaurant"."business_status"), "tags" = COALESCE(UPDATED."tags", "Restaurant"."tags"), "image_url" = COALESCE(UPDATED."image_url", "Restaurant"."image_url"), "rating" = COALESCE(UPDATED."rating", "Restaurant"."rating"), "user_ratings_total" = COALESCE(UPDATED."user_ratings_total", "Restaurant"."user_ratings_total"), "open_now" = COALESCE(UPDATED."open_now", "Restaurant"."open_now"), "popular" = COALESCE(UPDATED."popular", "Restaurant"."popular")\n'
          'FROM ( VALUES ${requests.map((r) => '( ${values.add(r.placeId)}:text::text, ${values.add(r.name)}:text::text, ${values.add(r.latitude)}:float8::float8, ${values.add(r.longitude)}:float8::float8, ${values.add(r.businessStatus)}:text::text, ${values.add(r.tags)}:_text::_text, ${values.add(r.imageUrl)}:text::text, ${values.add(r.rating)}:float8::float8, ${values.add(r.userRatingsTotal)}:int8::int8, ${values.add(r.openNow)}:boolean::boolean, ${values.add(r.popular)}:boolean::boolean )').join(', ')} )\n'
          'AS UPDATED("place_id", "name", "latitude", "longitude", "business_status", "tags", "image_url", "rating", "user_ratings_total", "open_now", "popular")\n'
          'WHERE "Restaurant"."place_id" = UPDATED."place_id"'),
      parameters: values.values,
    );
  }
}

class DBRestaurantInsertRequest {
  DBRestaurantInsertRequest({
    required this.placeId,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.businessStatus,
    required this.tags,
    required this.imageUrl,
    required this.rating,
    required this.userRatingsTotal,
    required this.openNow,
    required this.popular,
  });

  final String placeId;
  final String name;
  final double latitude;
  final double longitude;
  final String businessStatus;
  final List<String> tags;
  final String imageUrl;
  final double rating;
  final int userRatingsTotal;
  final bool openNow;
  final bool popular;
}

class DBRestaurantUpdateRequest {
  DBRestaurantUpdateRequest({
    required this.placeId,
    this.name,
    this.latitude,
    this.longitude,
    this.businessStatus,
    this.tags,
    this.imageUrl,
    this.rating,
    this.userRatingsTotal,
    this.openNow,
    this.popular,
  });

  final String placeId;
  final String? name;
  final double? latitude;
  final double? longitude;
  final String? businessStatus;
  final List<String>? tags;
  final String? imageUrl;
  final double? rating;
  final int? userRatingsTotal;
  final bool? openNow;
  final bool? popular;
}

class DbrestaurantViewQueryable extends KeyedViewQueryable<DbrestaurantView, String> {
  @override
  String get keyName => 'place_id';

  @override
  String encodeKey(String key) => TextEncoder.i.encode(key);

  @override
  String get query => 'SELECT "Restaurant".*, "menu"."data" as "menu"'
      'FROM "Restaurant"'
      'LEFT JOIN ('
      '  SELECT "Menu"."restaurant_place_id",'
      '    to_jsonb(array_agg("Menu".*)) as data'
      '  FROM (${DbmenuViewQueryable().query}) "Menu"'
      '  GROUP BY "Menu"."restaurant_place_id"'
      ') "menu"'
      'ON "Restaurant"."place_id" = "menu"."restaurant_place_id"';

  @override
  String get tableAlias => 'Restaurant';

  @override
  DbrestaurantView decode(TypedMap map) => DbrestaurantView(
      placeId: map.get('place_id'),
      name: map.get('name'),
      latitude: map.get('latitude'),
      longitude: map.get('longitude'),
      businessStatus: map.get('business_status'),
      tags: map.getListOpt('tags') ?? const [],
      menu: map.getListOpt('menu', DbmenuViewQueryable().decoder),
      imageUrl: map.get('image_url'),
      rating: map.get('rating'),
      userRatingsTotal: map.get('user_ratings_total'),
      openNow: map.get('open_now'),
      popular: map.get('popular'));
}

class DbrestaurantView {
  DbrestaurantView({
    required this.placeId,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.businessStatus,
    required this.tags,
    this.menu,
    required this.imageUrl,
    required this.rating,
    required this.userRatingsTotal,
    required this.openNow,
    required this.popular,
  });

  final String placeId;
  final String name;
  final double latitude;
  final double longitude;
  final String businessStatus;
  final List<String> tags;
  final List<DbmenuView>? menu;
  final String imageUrl;
  final double rating;
  final int userRatingsTotal;
  final bool openNow;
  final bool popular;
}
