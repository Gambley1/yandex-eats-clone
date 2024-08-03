// ignore_for_file: annotate_overrides

part of 'db_menu_item.dart';

extension DbMenuItemRepositories on Session {
  DBMenuItemRepository get dbmenuItems => DBMenuItemRepository._(this);
}

abstract class DBMenuItemRepository
    implements
        ModelRepository,
        KeyedModelRepositoryInsert<DBMenuItemInsertRequest>,
        ModelRepositoryUpdate<DBMenuItemUpdateRequest>,
        ModelRepositoryDelete<int> {
  factory DBMenuItemRepository._(Session db) = _DBMenuItemRepository;

  Future<DbmenuItemView?> queryDbmenuItem(int id);
  Future<List<DbmenuItemView>> queryDbmenuItems([QueryParams? params]);
}

class _DBMenuItemRepository extends BaseRepository
    with
        KeyedRepositoryInsertMixin<DBMenuItemInsertRequest>,
        RepositoryUpdateMixin<DBMenuItemUpdateRequest>,
        RepositoryDeleteMixin<int>
    implements DBMenuItemRepository {
  _DBMenuItemRepository(super.db) : super(tableName: 'MenuItem', keyName: 'id');

  @override
  Future<DbmenuItemView?> queryDbmenuItem(int id) {
    return queryOne(id, DbmenuItemViewQueryable());
  }

  @override
  Future<List<DbmenuItemView>> queryDbmenuItems([QueryParams? params]) {
    return queryMany(DbmenuItemViewQueryable(), params);
  }

  @override
  Future<List<int>> insert(List<DBMenuItemInsertRequest> requests) async {
    if (requests.isEmpty) return [];
    var values = QueryValues();
    var rows = await db.execute(
      Sql.named(
          'INSERT INTO "MenuItem" ( "name", "description", "image_url", "price", "discount", "menu_id" )\n'
          'VALUES ${requests.map((r) => '( ${values.add(r.name)}:text, ${values.add(r.description)}:text, ${values.add(r.imageUrl)}:text, ${values.add(r.price)}:float8, ${values.add(r.discount)}:float8, ${values.add(r.menuId)}:int8 )').join(', ')}\n'
          'RETURNING "id"'),
      parameters: values.values,
    );
    var result = rows.map<int>((r) => TextEncoder.i.decode(r.toColumnMap()['id'])).toList();

    return result;
  }

  @override
  Future<void> update(List<DBMenuItemUpdateRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.execute(
      Sql.named('UPDATE "MenuItem"\n'
          'SET "name" = COALESCE(UPDATED."name", "MenuItem"."name"), "description" = COALESCE(UPDATED."description", "MenuItem"."description"), "image_url" = COALESCE(UPDATED."image_url", "MenuItem"."image_url"), "price" = COALESCE(UPDATED."price", "MenuItem"."price"), "discount" = COALESCE(UPDATED."discount", "MenuItem"."discount"), "menu_id" = COALESCE(UPDATED."menu_id", "MenuItem"."menu_id")\n'
          'FROM ( VALUES ${requests.map((r) => '( ${values.add(r.id)}:int8::int8, ${values.add(r.name)}:text::text, ${values.add(r.description)}:text::text, ${values.add(r.imageUrl)}:text::text, ${values.add(r.price)}:float8::float8, ${values.add(r.discount)}:float8::float8, ${values.add(r.menuId)}:int8::int8 )').join(', ')} )\n'
          'AS UPDATED("id", "name", "description", "image_url", "price", "discount", "menu_id")\n'
          'WHERE "MenuItem"."id" = UPDATED."id"'),
      parameters: values.values,
    );
  }
}

class DBMenuItemInsertRequest {
  DBMenuItemInsertRequest({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.discount,
    this.menuId,
  });

  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final double discount;
  final int? menuId;
}

class DBMenuItemUpdateRequest {
  DBMenuItemUpdateRequest({
    required this.id,
    this.name,
    this.description,
    this.imageUrl,
    this.price,
    this.discount,
    this.menuId,
  });

  final int id;
  final String? name;
  final String? description;
  final String? imageUrl;
  final double? price;
  final double? discount;
  final int? menuId;
}

class DbmenuItemViewQueryable extends KeyedViewQueryable<DbmenuItemView, int> {
  @override
  String get keyName => 'id';

  @override
  String encodeKey(int key) => TextEncoder.i.encode(key);

  @override
  String get query => 'SELECT "MenuItem".*'
      'FROM "MenuItem"';

  @override
  String get tableAlias => 'MenuItem';

  @override
  DbmenuItemView decode(TypedMap map) => DbmenuItemView(
      id: map.get('id'),
      name: map.get('name'),
      description: map.get('description'),
      imageUrl: map.get('image_url'),
      price: map.get('price'),
      discount: map.get('discount'));
}

class DbmenuItemView {
  DbmenuItemView({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.discount,
  });

  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final double discount;
}
