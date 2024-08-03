// ignore_for_file: annotate_overrides

part of 'db_user_notification.dart';

extension DbUserNotificationRepositories on Session {
  DBUserNotificationRepository get dbuserNotifications => DBUserNotificationRepository._(this);
}

abstract class DBUserNotificationRepository
    implements
        ModelRepository,
        ModelRepositoryInsert<DBUserNotificationInsertRequest>,
        ModelRepositoryUpdate<DBUserNotificationUpdateRequest>,
        ModelRepositoryDelete<String> {
  factory DBUserNotificationRepository._(Session db) = _DBUserNotificationRepository;

  Future<DbuserNotificationView?> queryDbuserNotification(String id);
  Future<List<DbuserNotificationView>> queryDbuserNotifications([QueryParams? params]);
}

class _DBUserNotificationRepository extends BaseRepository
    with
        RepositoryInsertMixin<DBUserNotificationInsertRequest>,
        RepositoryUpdateMixin<DBUserNotificationUpdateRequest>,
        RepositoryDeleteMixin<String>
    implements DBUserNotificationRepository {
  _DBUserNotificationRepository(super.db) : super(tableName: 'User notification', keyName: 'id');

  @override
  Future<DbuserNotificationView?> queryDbuserNotification(String id) {
    return queryOne(id, DbuserNotificationViewQueryable());
  }

  @override
  Future<List<DbuserNotificationView>> queryDbuserNotifications([QueryParams? params]) {
    return queryMany(DbuserNotificationViewQueryable(), params);
  }

  @override
  Future<void> insert(List<DBUserNotificationInsertRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.execute(
      Sql.named(
          'INSERT INTO "User notification" ( "id", "message", "date", "is_read", "user_uid" )\n'
          'VALUES ${requests.map((r) => '( ${values.add(r.id)}:text, ${values.add(r.message)}:text, ${values.add(r.date)}:text, ${values.add(r.isRead)}:boolean, ${values.add(r.userUid)}:text )').join(', ')}\n'),
      parameters: values.values,
    );
  }

  @override
  Future<void> update(List<DBUserNotificationUpdateRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.execute(
      Sql.named('UPDATE "User notification"\n'
          'SET "message" = COALESCE(UPDATED."message", "User notification"."message"), "date" = COALESCE(UPDATED."date", "User notification"."date"), "is_read" = COALESCE(UPDATED."is_read", "User notification"."is_read"), "user_uid" = COALESCE(UPDATED."user_uid", "User notification"."user_uid")\n'
          'FROM ( VALUES ${requests.map((r) => '( ${values.add(r.id)}:text::text, ${values.add(r.message)}:text::text, ${values.add(r.date)}:text::text, ${values.add(r.isRead)}:boolean::boolean, ${values.add(r.userUid)}:text::text )').join(', ')} )\n'
          'AS UPDATED("id", "message", "date", "is_read", "user_uid")\n'
          'WHERE "User notification"."id" = UPDATED."id"'),
      parameters: values.values,
    );
  }
}

class DBUserNotificationInsertRequest {
  DBUserNotificationInsertRequest({
    required this.id,
    required this.message,
    required this.date,
    this.isRead,
    this.userUid,
  });

  final String id;
  final String message;
  final String date;
  final bool? isRead;
  final String? userUid;
}

class DBUserNotificationUpdateRequest {
  DBUserNotificationUpdateRequest({
    required this.id,
    this.message,
    this.date,
    this.isRead,
    this.userUid,
  });

  final String id;
  final String? message;
  final String? date;
  final bool? isRead;
  final String? userUid;
}

class DbuserNotificationViewQueryable extends KeyedViewQueryable<DbuserNotificationView, String> {
  @override
  String get keyName => 'id';

  @override
  String encodeKey(String key) => TextEncoder.i.encode(key);

  @override
  String get query => 'SELECT "User notification".*'
      'FROM "User notification"';

  @override
  String get tableAlias => 'User notification';

  @override
  DbuserNotificationView decode(TypedMap map) => DbuserNotificationView(
      id: map.get('id'),
      message: map.get('message'),
      date: map.get('date'),
      isRead: map.getOpt('is_read'));
}

class DbuserNotificationView {
  DbuserNotificationView({
    required this.id,
    required this.message,
    required this.date,
    this.isRead,
  });

  final String id;
  final String message;
  final String date;
  final bool? isRead;
}
