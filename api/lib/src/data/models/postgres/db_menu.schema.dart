// ignore_for_file: annotate_overrides

part of 'db_menu.dart';

extension DbMenuRepositories on Session {
  DBMenuRepository get dbmenus => DBMenuRepository._(this);
}

abstract class DBMenuRepository
    implements
        ModelRepository,
        KeyedModelRepositoryInsert<DBMenuInsertRequest>,
        ModelRepositoryUpdate<DBMenuUpdateRequest>,
        ModelRepositoryDelete<int> {
  factory DBMenuRepository._(Session db) = _DBMenuRepository;

  Future<DbmenuView?> queryDbmenu(int id);
  Future<List<DbmenuView>> queryDbmenus([QueryParams? params]);
}

class _DBMenuRepository extends BaseRepository
    with
        KeyedRepositoryInsertMixin<DBMenuInsertRequest>,
        RepositoryUpdateMixin<DBMenuUpdateRequest>,
        RepositoryDeleteMixin<int>
    implements DBMenuRepository {
  _DBMenuRepository(super.db) : super(tableName: 'Menu', keyName: 'id');

  @override
  Future<DbmenuView?> queryDbmenu(int id) {
    return queryOne(id, DbmenuViewQueryable());
  }

  @override
  Future<List<DbmenuView>> queryDbmenus([QueryParams? params]) {
    return queryMany(DbmenuViewQueryable(), params);
  }

  @override
  Future<List<int>> insert(List<DBMenuInsertRequest> requests) async {
    if (requests.isEmpty) return [];
    var values = QueryValues();
    var rows = await db.execute(
      Sql.named('INSERT INTO "Menu" ( "category", "restaurant_place_id" )\n'
          'VALUES ${requests.map((r) => '( ${values.add(r.category)}:text, ${values.add(r.restaurantPlaceId)}:text )').join(', ')}\n'
          'RETURNING "id"'),
      parameters: values.values,
    );
    var result = rows.map<int>((r) => TextEncoder.i.decode(r.toColumnMap()['id'])).toList();

    return result;
  }

  @override
  Future<void> update(List<DBMenuUpdateRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.execute(
      Sql.named('UPDATE "Menu"\n'
          'SET "category" = COALESCE(UPDATED."category", "Menu"."category"), "restaurant_place_id" = COALESCE(UPDATED."restaurant_place_id", "Menu"."restaurant_place_id")\n'
          'FROM ( VALUES ${requests.map((r) => '( ${values.add(r.id)}:int8::int8, ${values.add(r.category)}:text::text, ${values.add(r.restaurantPlaceId)}:text::text )').join(', ')} )\n'
          'AS UPDATED("id", "category", "restaurant_place_id")\n'
          'WHERE "Menu"."id" = UPDATED."id"'),
      parameters: values.values,
    );
  }
}

class DBMenuInsertRequest {
  DBMenuInsertRequest({
    required this.category,
    this.restaurantPlaceId,
  });

  final String category;
  final String? restaurantPlaceId;
}

class DBMenuUpdateRequest {
  DBMenuUpdateRequest({
    required this.id,
    this.category,
    this.restaurantPlaceId,
  });

  final int id;
  final String? category;
  final String? restaurantPlaceId;
}

class DbmenuViewQueryable extends KeyedViewQueryable<DbmenuView, int> {
  @override
  String get keyName => 'id';

  @override
  String encodeKey(int key) => TextEncoder.i.encode(key);

  @override
  String get query => 'SELECT "Menu".*, "items"."data" as "items"'
      'FROM "Menu"'
      'LEFT JOIN ('
      '  SELECT "MenuItem"."menu_id",'
      '    to_jsonb(array_agg("MenuItem".*)) as data'
      '  FROM (${DbmenuItemViewQueryable().query}) "MenuItem"'
      '  GROUP BY "MenuItem"."menu_id"'
      ') "items"'
      'ON "Menu"."id" = "items"."menu_id"';

  @override
  String get tableAlias => 'Menu';

  @override
  DbmenuView decode(TypedMap map) => DbmenuView(
      id: map.get('id'),
      category: map.get('category'),
      items: map.getListOpt('items', DbmenuItemViewQueryable().decoder) ?? const []);
}

class DbmenuView {
  DbmenuView({
    required this.id,
    required this.category,
    required this.items,
  });

  final int id;
  final String category;
  final List<DbmenuItemView> items;
}
