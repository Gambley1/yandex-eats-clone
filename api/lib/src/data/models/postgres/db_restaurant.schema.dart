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
          'INSERT INTO "Restaurant" ( "place_id", "name", "popular", "latitude", "longitude", "business_status", "tags", "image_url", "rating", "user_ratings_total", "price_level", "open_now" )\n'
          'VALUES ${requests.map((r) => '( ${values.add(r.placeId)}:text, ${values.add(r.name)}:text, ${values.add(r.popular)}:boolean, ${values.add(r.latitude)}:float8, ${values.add(r.longitude)}:float8, ${values.add(r.businessStatus)}:text, ${values.add(r.tags)}:_text, ${values.add(r.imageUrl)}:text, ${values.add(r.rating)}:float8, ${values.add(r.userRatingsTotal)}:int8, ${values.add(r.priceLevel)}:int8, ${values.add(r.openNow)}:boolean )').join(', ')}\n'),
      parameters: values.values,
    );
  }

  @override
  Future<void> update(List<DBRestaurantUpdateRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.execute(
      Sql.named('UPDATE "Restaurant"\n'
          'SET "name" = COALESCE(UPDATED."name", "Restaurant"."name"), "popular" = COALESCE(UPDATED."popular", "Restaurant"."popular"), "latitude" = COALESCE(UPDATED."latitude", "Restaurant"."latitude"), "longitude" = COALESCE(UPDATED."longitude", "Restaurant"."longitude"), "business_status" = COALESCE(UPDATED."business_status", "Restaurant"."business_status"), "tags" = COALESCE(UPDATED."tags", "Restaurant"."tags"), "image_url" = COALESCE(UPDATED."image_url", "Restaurant"."image_url"), "rating" = COALESCE(UPDATED."rating", "Restaurant"."rating"), "user_ratings_total" = COALESCE(UPDATED."user_ratings_total", "Restaurant"."user_ratings_total"), "price_level" = COALESCE(UPDATED."price_level", "Restaurant"."price_level"), "open_now" = COALESCE(UPDATED."open_now", "Restaurant"."open_now")\n'
          'FROM ( VALUES ${requests.map((r) => '( ${values.add(r.placeId)}:text::text, ${values.add(r.name)}:text::text, ${values.add(r.popular)}:boolean::boolean, ${values.add(r.latitude)}:float8::float8, ${values.add(r.longitude)}:float8::float8, ${values.add(r.businessStatus)}:text::text, ${values.add(r.tags)}:_text::_text, ${values.add(r.imageUrl)}:text::text, ${values.add(r.rating)}:float8::float8, ${values.add(r.userRatingsTotal)}:int8::int8, ${values.add(r.priceLevel)}:int8::int8, ${values.add(r.openNow)}:boolean::boolean )').join(', ')} )\n'
          'AS UPDATED("place_id", "name", "popular", "latitude", "longitude", "business_status", "tags", "image_url", "rating", "user_ratings_total", "price_level", "open_now")\n'
          'WHERE "Restaurant"."place_id" = UPDATED."place_id"'),
      parameters: values.values,
    );
  }
}

class DBRestaurantInsertRequest {
  DBRestaurantInsertRequest({
    required this.placeId,
    required this.name,
    required this.popular,
    required this.latitude,
    required this.longitude,
    required this.businessStatus,
    required this.tags,
    required this.imageUrl,
    required this.rating,
    required this.userRatingsTotal,
    required this.priceLevel,
    required this.openNow,
  });

  final String placeId;
  final String name;
  final bool popular;
  final double latitude;
  final double longitude;
  final String businessStatus;
  final List<String> tags;
  final String imageUrl;
  final double rating;
  final int userRatingsTotal;
  final int priceLevel;
  final bool openNow;
}

class DBRestaurantUpdateRequest {
  DBRestaurantUpdateRequest({
    required this.placeId,
    this.name,
    this.popular,
    this.latitude,
    this.longitude,
    this.businessStatus,
    this.tags,
    this.imageUrl,
    this.rating,
    this.userRatingsTotal,
    this.priceLevel,
    this.openNow,
  });

  final String placeId;
  final String? name;
  final bool? popular;
  final double? latitude;
  final double? longitude;
  final String? businessStatus;
  final List<String>? tags;
  final String? imageUrl;
  final double? rating;
  final int? userRatingsTotal;
  final int? priceLevel;
  final bool? openNow;
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
      popular: map.get('popular'),
      latitude: map.get('latitude'),
      longitude: map.get('longitude'),
      businessStatus: map.get('business_status'),
      tags: map.getListOpt('tags') ?? const [],
      menu: map.getListOpt('menu', DbmenuViewQueryable().decoder),
      imageUrl: map.get('image_url'),
      rating: map.get('rating'),
      userRatingsTotal: map.get('user_ratings_total'),
      priceLevel: map.get('price_level'),
      openNow: map.get('open_now'));
}

class DbrestaurantView {
  DbrestaurantView({
    required this.placeId,
    required this.name,
    required this.popular,
    required this.latitude,
    required this.longitude,
    required this.businessStatus,
    required this.tags,
    this.menu,
    required this.imageUrl,
    required this.rating,
    required this.userRatingsTotal,
    required this.priceLevel,
    required this.openNow,
  });

  final String placeId;
  final String name;
  final bool popular;
  final double latitude;
  final double longitude;
  final String businessStatus;
  final List<String> tags;
  final List<DbmenuView>? menu;
  final String imageUrl;
  final double rating;
  final int userRatingsTotal;
  final int priceLevel;
  final bool openNow;
}
