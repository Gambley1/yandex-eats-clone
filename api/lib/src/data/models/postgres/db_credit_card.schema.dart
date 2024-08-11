// ignore_for_file: annotate_overrides

part of 'db_credit_card.dart';

extension DbCreditCardRepositories on Session {
  DBCreditCardRepository get dbcreditCards => DBCreditCardRepository._(this);
}

abstract class DBCreditCardRepository
    implements
        ModelRepository,
        KeyedModelRepositoryInsert<DBCreditCardInsertRequest>,
        ModelRepositoryUpdate<DBCreditCardUpdateRequest>,
        ModelRepositoryDelete<int> {
  factory DBCreditCardRepository._(Session db) = _DBCreditCardRepository;

  Future<DbcreditCardView?> queryDbcreditCard(int id);
  Future<List<DbcreditCardView>> queryDbcreditCards([QueryParams? params]);
}

class _DBCreditCardRepository extends BaseRepository
    with
        KeyedRepositoryInsertMixin<DBCreditCardInsertRequest>,
        RepositoryUpdateMixin<DBCreditCardUpdateRequest>,
        RepositoryDeleteMixin<int>
    implements DBCreditCardRepository {
  _DBCreditCardRepository(super.db)
      : super(tableName: 'Credit card', keyName: 'id');

  @override
  Future<DbcreditCardView?> queryDbcreditCard(int id) {
    return queryOne(id, DbcreditCardViewQueryable());
  }

  @override
  Future<List<DbcreditCardView>> queryDbcreditCards([QueryParams? params]) {
    return queryMany(DbcreditCardViewQueryable(), params);
  }

  @override
  Future<List<int>> insert(List<DBCreditCardInsertRequest> requests) async {
    if (requests.isEmpty) return [];
    var values = QueryValues();
    var rows = await db.execute(
      Sql.named(
          'INSERT INTO "Credit card" ( "number", "expiry_date", "cvv", "user_id" )\n'
          'VALUES ${requests.map((r) => '( ${values.add(r.number)}:text, ${values.add(r.expiryDate)}:text, ${values.add(r.cvv)}:text, ${values.add(r.userId)}:text )').join(', ')}\n'
          'RETURNING "id"'),
      parameters: values.values,
    );
    var result = rows
        .map<int>((r) => TextEncoder.i.decode(r.toColumnMap()['id']))
        .toList();

    return result;
  }

  @override
  Future<void> update(List<DBCreditCardUpdateRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.execute(
      Sql.named('UPDATE "Credit card"\n'
          'SET "number" = COALESCE(UPDATED."number", "Credit card"."number"), "expiry_date" = COALESCE(UPDATED."expiry_date", "Credit card"."expiry_date"), "cvv" = COALESCE(UPDATED."cvv", "Credit card"."cvv"), "user_id" = COALESCE(UPDATED."user_id", "Credit card"."user_id")\n'
          'FROM ( VALUES ${requests.map((r) => '( ${values.add(r.id)}:int8::int8, ${values.add(r.number)}:text::text, ${values.add(r.expiryDate)}:text::text, ${values.add(r.cvv)}:text::text, ${values.add(r.userId)}:text::text )').join(', ')} )\n'
          'AS UPDATED("id", "number", "expiry_date", "cvv", "user_id")\n'
          'WHERE "Credit card"."id" = UPDATED."id"'),
      parameters: values.values,
    );
  }
}

class DBCreditCardInsertRequest {
  DBCreditCardInsertRequest({
    required this.number,
    required this.expiryDate,
    required this.cvv,
    required this.userId,
  });

  final String number;
  final String expiryDate;
  final String cvv;
  final String userId;
}

class DBCreditCardUpdateRequest {
  DBCreditCardUpdateRequest({
    required this.id,
    this.number,
    this.expiryDate,
    this.cvv,
    this.userId,
  });

  final int id;
  final String? number;
  final String? expiryDate;
  final String? cvv;
  final String? userId;
}

class DbcreditCardViewQueryable
    extends KeyedViewQueryable<DbcreditCardView, int> {
  @override
  String get keyName => 'id';

  @override
  String encodeKey(int key) => TextEncoder.i.encode(key);

  @override
  String get query => 'SELECT "Credit card".*'
      'FROM "Credit card"';

  @override
  String get tableAlias => 'Credit card';

  @override
  DbcreditCardView decode(TypedMap map) => DbcreditCardView(
      id: map.get('id'),
      number: map.get('number'),
      expiryDate: map.get('expiry_date'),
      cvv: map.get('cvv'),
      userId: map.get('user_id'));
}

class DbcreditCardView {
  DbcreditCardView({
    required this.id,
    required this.number,
    required this.expiryDate,
    required this.cvv,
    required this.userId,
  });

  final int id;
  final String number;
  final String expiryDate;
  final String cvv;
  final String userId;
}
