import 'package:stormberry/stormberry.dart';
import 'package:yandex_food_api/api.dart';

class FindUserNotifications
    extends Query<List<DbnotificationView>, QueryParams> {
  const FindUserNotifications();

  @override
  Future<List<DbnotificationView>> apply(
    Session db,
    QueryParams params,
  ) async {
    final queryable = DbnotificationViewQueryable();
    final tableName = queryable.tableAlias;
    final query = '''
      SELECT * FROM "$tableName"
      WHERE user_uid = @user_id
    ''';

    final postgreSQLResult =
        await db.execute(Sql.named(query), parameters: params.values);

    return postgreSQLResult
        .map((row) => queryable.decode(TypedMap(row.toColumnMap())))
        .toList();
  }
}
