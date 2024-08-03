// ignore_for_file: annotate_overrides

part of 'db_order_details.dart';

extension DbOrderDetailsRepositories on Session {
  DBOrderDetailsRepository get dborderDetailses => DBOrderDetailsRepository._(this);
}

abstract class DBOrderDetailsRepository
    implements
        ModelRepository,
        ModelRepositoryInsert<DBOrderDetailsInsertRequest>,
        ModelRepositoryUpdate<DBOrderDetailsUpdateRequest>,
        ModelRepositoryDelete<String> {
  factory DBOrderDetailsRepository._(Session db) = _DBOrderDetailsRepository;

  Future<DborderDetailsView?> queryDborderDetails(String id);
  Future<List<DborderDetailsView>> queryDborderDetailses([QueryParams? params]);
}

class _DBOrderDetailsRepository extends BaseRepository
    with
        RepositoryInsertMixin<DBOrderDetailsInsertRequest>,
        RepositoryUpdateMixin<DBOrderDetailsUpdateRequest>,
        RepositoryDeleteMixin<String>
    implements DBOrderDetailsRepository {
  _DBOrderDetailsRepository(super.db) : super(tableName: 'Order details', keyName: 'id');

  @override
  Future<DborderDetailsView?> queryDborderDetails(String id) {
    return queryOne(id, DborderDetailsViewQueryable());
  }

  @override
  Future<List<DborderDetailsView>> queryDborderDetailses([QueryParams? params]) {
    return queryMany(DborderDetailsViewQueryable(), params);
  }

  @override
  Future<void> insert(List<DBOrderDetailsInsertRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.execute(
      Sql.named(
          'INSERT INTO "Order details" ( "id", "user_id", "status", "date", "restaurant_place_id", "restaurant_name", "order_address", "total_order_sum", "order_delivery_fee" )\n'
          'VALUES ${requests.map((r) => '( ${values.add(r.id)}:text, ${values.add(r.userId)}:text, ${values.add(r.status)}:text, ${values.add(r.date)}:text, ${values.add(r.restaurantPlaceId)}:text, ${values.add(r.restaurantName)}:text, ${values.add(r.orderAddress)}:text, ${values.add(r.totalOrderSum)}:float8, ${values.add(r.orderDeliveryFee)}:float8 )').join(', ')}\n'),
      parameters: values.values,
    );
  }

  @override
  Future<void> update(List<DBOrderDetailsUpdateRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.execute(
      Sql.named('UPDATE "Order details"\n'
          'SET "user_id" = COALESCE(UPDATED."user_id", "Order details"."user_id"), "status" = COALESCE(UPDATED."status", "Order details"."status"), "date" = COALESCE(UPDATED."date", "Order details"."date"), "restaurant_place_id" = COALESCE(UPDATED."restaurant_place_id", "Order details"."restaurant_place_id"), "restaurant_name" = COALESCE(UPDATED."restaurant_name", "Order details"."restaurant_name"), "order_address" = COALESCE(UPDATED."order_address", "Order details"."order_address"), "total_order_sum" = COALESCE(UPDATED."total_order_sum", "Order details"."total_order_sum"), "order_delivery_fee" = COALESCE(UPDATED."order_delivery_fee", "Order details"."order_delivery_fee")\n'
          'FROM ( VALUES ${requests.map((r) => '( ${values.add(r.id)}:text::text, ${values.add(r.userId)}:text::text, ${values.add(r.status)}:text::text, ${values.add(r.date)}:text::text, ${values.add(r.restaurantPlaceId)}:text::text, ${values.add(r.restaurantName)}:text::text, ${values.add(r.orderAddress)}:text::text, ${values.add(r.totalOrderSum)}:float8::float8, ${values.add(r.orderDeliveryFee)}:float8::float8 )').join(', ')} )\n'
          'AS UPDATED("id", "user_id", "status", "date", "restaurant_place_id", "restaurant_name", "order_address", "total_order_sum", "order_delivery_fee")\n'
          'WHERE "Order details"."id" = UPDATED."id"'),
      parameters: values.values,
    );
  }
}

class DBOrderDetailsInsertRequest {
  DBOrderDetailsInsertRequest({
    required this.id,
    required this.userId,
    required this.status,
    required this.date,
    required this.restaurantPlaceId,
    required this.restaurantName,
    required this.orderAddress,
    required this.totalOrderSum,
    required this.orderDeliveryFee,
  });

  final String id;
  final String userId;
  final String status;
  final String date;
  final String restaurantPlaceId;
  final String restaurantName;
  final String orderAddress;
  final double totalOrderSum;
  final double orderDeliveryFee;
}

class DBOrderDetailsUpdateRequest {
  DBOrderDetailsUpdateRequest({
    required this.id,
    this.userId,
    this.status,
    this.date,
    this.restaurantPlaceId,
    this.restaurantName,
    this.orderAddress,
    this.totalOrderSum,
    this.orderDeliveryFee,
  });

  final String id;
  final String? userId;
  final String? status;
  final String? date;
  final String? restaurantPlaceId;
  final String? restaurantName;
  final String? orderAddress;
  final double? totalOrderSum;
  final double? orderDeliveryFee;
}

class DborderDetailsViewQueryable extends KeyedViewQueryable<DborderDetailsView, String> {
  @override
  String get keyName => 'id';

  @override
  String encodeKey(String key) => TextEncoder.i.encode(key);

  @override
  String get query => 'SELECT "Order details".*, "orderMenuItems"."data" as "orderMenuItems"'
      'FROM "Order details"'
      'LEFT JOIN ('
      '  SELECT "Order menu items"."order_details_id",'
      '    to_jsonb(array_agg("Order menu items".*)) as data'
      '  FROM (${DborderMenuItemViewQueryable().query}) "Order menu items"'
      '  GROUP BY "Order menu items"."order_details_id"'
      ') "orderMenuItems"'
      'ON "Order details"."id" = "orderMenuItems"."order_details_id"';

  @override
  String get tableAlias => 'Order details';

  @override
  DborderDetailsView decode(TypedMap map) => DborderDetailsView(
      id: map.get('id'),
      userId: map.get('user_id'),
      status: map.get('status'),
      date: map.get('date'),
      restaurantPlaceId: map.get('restaurant_place_id'),
      restaurantName: map.get('restaurant_name'),
      orderAddress: map.get('order_address'),
      orderMenuItems:
          map.getListOpt('orderMenuItems', DborderMenuItemViewQueryable().decoder) ?? const [],
      totalOrderSum: map.get('total_order_sum'),
      orderDeliveryFee: map.get('order_delivery_fee'));
}

class DborderDetailsView {
  DborderDetailsView({
    required this.id,
    required this.userId,
    required this.status,
    required this.date,
    required this.restaurantPlaceId,
    required this.restaurantName,
    required this.orderAddress,
    required this.orderMenuItems,
    required this.totalOrderSum,
    required this.orderDeliveryFee,
  });

  final String id;
  final String userId;
  final String status;
  final String date;
  final String restaurantPlaceId;
  final String restaurantName;
  final String orderAddress;
  final List<DborderMenuItemView> orderMenuItems;
  final double totalOrderSum;
  final double orderDeliveryFee;
}
