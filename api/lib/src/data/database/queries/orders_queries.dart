import 'package:stormberry/stormberry.dart';
import 'package:yandex_food_api/api.dart';

class FindUserOrderById extends Query<DborderDetailsView?, QueryParams> {
  const FindUserOrderById();

  @override
  Future<DborderDetailsView?> apply(Session db, QueryParams params) async {
    final queryable = DborderDetailsViewQueryable();
    final tableName = queryable.tableAlias;
    final query = '''
      SELECT * FROM "$tableName"
      WHERE user_id = @user_id AND id = @order_id
    ''';

    final postgreSQLResult =
        await db.execute(Sql.named(query), parameters: params.values);

    final objects = postgreSQLResult
        .map((row) => queryable.decode(TypedMap(row.toColumnMap())))
        .toList();
    return objects.firstOrNull;
  }
}

class FindUserOrders extends Query<List<DborderDetailsView>, QueryParams> {
  const FindUserOrders();

  @override
  Future<List<DborderDetailsView>> apply(
    Session db,
    QueryParams params,
  ) async {
    final queryable = DborderDetailsViewQueryable();
    final tableName = queryable.tableAlias;
    final query = '''
      SELECT * FROM "$tableName"
      WHERE user_id = @user_id
    ''';

    final postgreSQLResult =
        await db.execute(Sql.named(query), parameters: params.values);

    final objects = postgreSQLResult
        .map((row) => queryable.decode(TypedMap(row.toColumnMap())))
        .toList();
    return objects;
  }
}

class FindOrderMenuItemIds extends Query<List<int>, QueryParams> {
  const FindOrderMenuItemIds();

  @override
  Future<List<int>> apply(
    Session db,
    QueryParams params,
  ) async {
    final queryable = DborderMenuItemViewQueryable();
    final tableName = queryable.tableAlias;
    final query = '''
      SELECT * FROM "$tableName"
      WHERE order_details_id=@order_id
    ''';

    final postgreSQLResult =
        await db.execute(Sql.named(query), parameters: params.values);

    return postgreSQLResult
        .map((row) => queryable.decode(TypedMap(row.toColumnMap())).id)
        .toList();
  }
}
