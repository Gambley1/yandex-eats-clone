import 'package:stormberry/stormberry.dart';
import 'package:yandex_food_api/api.dart';

class FindUserCreditCard extends Query<DbcreditCardView?, QueryParams> {
  const FindUserCreditCard();

  @override
  Future<DbcreditCardView?> apply(Session db, QueryParams params) async {
    final queryable = DbcreditCardViewQueryable();
    final tableName = queryable.tableAlias;
    final query = '''
      SELECT * FROM "$tableName"
      WHERE user_id=@user_id
    ''';

    final postgreSQLResult =
        await db.execute(Sql.named(query), parameters: params.values);

    final objects = postgreSQLResult
        .map((row) => queryable.decode(TypedMap(row.toColumnMap())))
        .toList();
    return objects.firstOrNull;
  }
}

class FindUserCreditCardByNumber extends Query<DbcreditCardView?, QueryParams> {
  const FindUserCreditCardByNumber();

  @override
  Future<DbcreditCardView?> apply(Session db, QueryParams params) async {
    final queryable = DbcreditCardViewQueryable();
    final tableName = queryable.tableAlias;
    final query = '''
      SELECT * FROM "$tableName"
      WHERE user_id=@user_id AND number=@number
    ''';

    final postgreSQLResult =
        await db.execute(Sql.named(query), parameters: params.values);

    final objects = postgreSQLResult
        .map((row) => queryable.decode(TypedMap(row.toColumnMap())))
        .toList();
    return objects.isNotEmpty ? objects.first : null;
  }
}

class FindUserCreditCards extends Query<List<DbcreditCardView>, QueryParams> {
  const FindUserCreditCards();

  @override
  Future<List<DbcreditCardView>> apply(
    Session db,
    QueryParams params,
  ) async {
    final queryable = DbcreditCardViewQueryable();
    final tableName = queryable.tableAlias;
    final query = '''
      SELECT * FROM "$tableName"
      WHERE user_id=@user_id
    ''';

    final postgreSQLResult =
        await db.execute(Sql.named(query), parameters: params.values);

    return postgreSQLResult
        .map((row) => queryable.decode(TypedMap(row.toColumnMap())))
        .toList();
  }
}
