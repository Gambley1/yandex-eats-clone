// ignore_for_file: annotate_overrides

part of 'db_order_menu_item.dart';

extension DbOrderMenuItemRepositories on Session {
  DBOrderMenuItemRepository get dborderMenuItems =>
      DBOrderMenuItemRepository._(this);
}

abstract class DBOrderMenuItemRepository
    implements
        ModelRepository,
        KeyedModelRepositoryInsert<DBOrderMenuItemInsertRequest>,
        ModelRepositoryUpdate<DBOrderMenuItemUpdateRequest>,
        ModelRepositoryDelete<int> {
  factory DBOrderMenuItemRepository._(Session db) = _DBOrderMenuItemRepository;

  Future<DborderMenuItemView?> queryDborderMenuItem(int id);
  Future<List<DborderMenuItemView>> queryDborderMenuItems(
      [QueryParams? params]);
}

class _DBOrderMenuItemRepository extends BaseRepository
    with
        KeyedRepositoryInsertMixin<DBOrderMenuItemInsertRequest>,
        RepositoryUpdateMixin<DBOrderMenuItemUpdateRequest>,
        RepositoryDeleteMixin<int>
    implements DBOrderMenuItemRepository {
  _DBOrderMenuItemRepository(super.db)
      : super(tableName: 'Order menu items', keyName: 'id');

  @override
  Future<DborderMenuItemView?> queryDborderMenuItem(int id) {
    return queryOne(id, DborderMenuItemViewQueryable());
  }

  @override
  Future<List<DborderMenuItemView>> queryDborderMenuItems(
      [QueryParams? params]) {
    return queryMany(DborderMenuItemViewQueryable(), params);
  }

  @override
  Future<List<int>> insert(List<DBOrderMenuItemInsertRequest> requests) async {
    if (requests.isEmpty) return [];
    var values = QueryValues();
    var rows = await db.execute(
      Sql.named(
          'INSERT INTO "Order menu items" ( "name", "quantity", "price", "image_url", "order_details_id" )\n'
          'VALUES ${requests.map((r) => '( ${values.add(r.name)}:text, ${values.add(r.quantity)}:int8, ${values.add(r.price)}:float8, ${values.add(r.imageUrl)}:text, ${values.add(r.orderDetailsId)}:text )').join(', ')}\n'
          'RETURNING "id"'),
      parameters: values.values,
    );
    var result = rows
        .map<int>((r) => TextEncoder.i.decode(r.toColumnMap()['id']))
        .toList();

    return result;
  }

  @override
  Future<void> update(List<DBOrderMenuItemUpdateRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.execute(
      Sql.named('UPDATE "Order menu items"\n'
          'SET "name" = COALESCE(UPDATED."name", "Order menu items"."name"), "quantity" = COALESCE(UPDATED."quantity", "Order menu items"."quantity"), "price" = COALESCE(UPDATED."price", "Order menu items"."price"), "image_url" = COALESCE(UPDATED."image_url", "Order menu items"."image_url"), "order_details_id" = COALESCE(UPDATED."order_details_id", "Order menu items"."order_details_id")\n'
          'FROM ( VALUES ${requests.map((r) => '( ${values.add(r.id)}:int8::int8, ${values.add(r.name)}:text::text, ${values.add(r.quantity)}:int8::int8, ${values.add(r.price)}:float8::float8, ${values.add(r.imageUrl)}:text::text, ${values.add(r.orderDetailsId)}:text::text )').join(', ')} )\n'
          'AS UPDATED("id", "name", "quantity", "price", "image_url", "order_details_id")\n'
          'WHERE "Order menu items"."id" = UPDATED."id"'),
      parameters: values.values,
    );
  }
}

class DBOrderMenuItemInsertRequest {
  DBOrderMenuItemInsertRequest({
    required this.name,
    required this.quantity,
    required this.price,
    required this.imageUrl,
    this.orderDetailsId,
  });

  final String name;
  final int quantity;
  final double price;
  final String imageUrl;
  final String? orderDetailsId;
}

class DBOrderMenuItemUpdateRequest {
  DBOrderMenuItemUpdateRequest({
    required this.id,
    this.name,
    this.quantity,
    this.price,
    this.imageUrl,
    this.orderDetailsId,
  });

  final int id;
  final String? name;
  final int? quantity;
  final double? price;
  final String? imageUrl;
  final String? orderDetailsId;
}

class DborderMenuItemViewQueryable
    extends KeyedViewQueryable<DborderMenuItemView, int> {
  @override
  String get keyName => 'id';

  @override
  String encodeKey(int key) => TextEncoder.i.encode(key);

  @override
  String get query => 'SELECT "Order menu items".*'
      'FROM "Order menu items"';

  @override
  String get tableAlias => 'Order menu items';

  @override
  DborderMenuItemView decode(TypedMap map) => DborderMenuItemView(
      id: map.get('id'),
      name: map.get('name'),
      quantity: map.get('quantity'),
      price: map.get('price'),
      imageUrl: map.get('image_url'));
}

class DborderMenuItemView {
  DborderMenuItemView({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });

  final int id;
  final String name;
  final int quantity;
  final double price;
  final String imageUrl;
}
