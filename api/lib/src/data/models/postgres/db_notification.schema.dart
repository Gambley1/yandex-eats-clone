// ignore_for_file: annotate_overrides

part of 'db_notification.dart';

extension DbNotificationRepositories on Session {
  DBNotificationRepository get dbnotifications => DBNotificationRepository._(this);
}

abstract class DBNotificationRepository
    implements
        ModelRepository,
        KeyedModelRepositoryInsert<DBNotificationInsertRequest>,
        ModelRepositoryUpdate<DBNotificationUpdateRequest>,
        ModelRepositoryDelete<int> {
  factory DBNotificationRepository._(Session db) = _DBNotificationRepository;

  Future<DbnotificationView?> queryDbnotification(int id);
  Future<List<DbnotificationView>> queryDbnotifications([QueryParams? params]);
}

class _DBNotificationRepository extends BaseRepository
    with
        KeyedRepositoryInsertMixin<DBNotificationInsertRequest>,
        RepositoryUpdateMixin<DBNotificationUpdateRequest>,
        RepositoryDeleteMixin<int>
    implements DBNotificationRepository {
  _DBNotificationRepository(super.db) : super(tableName: 'Notification', keyName: 'id');

  @override
  Future<DbnotificationView?> queryDbnotification(int id) {
    return queryOne(id, DbnotificationViewQueryable());
  }

  @override
  Future<List<DbnotificationView>> queryDbnotifications([QueryParams? params]) {
    return queryMany(DbnotificationViewQueryable(), params);
  }

  @override
  Future<List<int>> insert(List<DBNotificationInsertRequest> requests) async {
    if (requests.isEmpty) return [];
    var values = QueryValues();
    var rows = await db.execute(
      Sql.named('INSERT INTO "Notification" ( "user_id", "message", "date", "is_important" )\n'
          'VALUES ${requests.map((r) => '( ${values.add(r.userId)}:text, ${values.add(r.message)}:text, ${values.add(r.date)}:text, ${values.add(r.isImportant)}:boolean )').join(', ')}\n'
          'RETURNING "id"'),
      parameters: values.values,
    );
    var result = rows.map<int>((r) => TextEncoder.i.decode(r.toColumnMap()['id'])).toList();

    return result;
  }

  @override
  Future<void> update(List<DBNotificationUpdateRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.execute(
      Sql.named('UPDATE "Notification"\n'
          'SET "user_id" = COALESCE(UPDATED."user_id", "Notification"."user_id"), "message" = COALESCE(UPDATED."message", "Notification"."message"), "date" = COALESCE(UPDATED."date", "Notification"."date"), "is_important" = COALESCE(UPDATED."is_important", "Notification"."is_important")\n'
          'FROM ( VALUES ${requests.map((r) => '( ${values.add(r.id)}:int8::int8, ${values.add(r.userId)}:text::text, ${values.add(r.message)}:text::text, ${values.add(r.date)}:text::text, ${values.add(r.isImportant)}:boolean::boolean )').join(', ')} )\n'
          'AS UPDATED("id", "user_id", "message", "date", "is_important")\n'
          'WHERE "Notification"."id" = UPDATED."id"'),
      parameters: values.values,
    );
  }
}

class DBNotificationInsertRequest {
  DBNotificationInsertRequest({
    required this.userId,
    required this.message,
    required this.date,
    required this.isImportant,
  });

  final String userId;
  final String message;
  final String date;
  final bool isImportant;
}

class DBNotificationUpdateRequest {
  DBNotificationUpdateRequest({
    required this.id,
    this.userId,
    this.message,
    this.date,
    this.isImportant,
  });

  final int id;
  final String? userId;
  final String? message;
  final String? date;
  final bool? isImportant;
}

class DbnotificationViewQueryable extends KeyedViewQueryable<DbnotificationView, int> {
  @override
  String get keyName => 'id';

  @override
  String encodeKey(int key) => TextEncoder.i.encode(key);

  @override
  String get query => 'SELECT "Notification".*'
      'FROM "Notification"';

  @override
  String get tableAlias => 'Notification';

  @override
  DbnotificationView decode(TypedMap map) => DbnotificationView(
      id: map.get('id'),
      userId: map.get('user_id'),
      message: map.get('message'),
      date: map.get('date'),
      isImportant: map.get('is_important'));
}

class DbnotificationView {
  DbnotificationView({
    required this.id,
    required this.userId,
    required this.message,
    required this.date,
    required this.isImportant,
  });

  final int id;
  final String userId;
  final String message;
  final String date;
  final bool isImportant;
}
