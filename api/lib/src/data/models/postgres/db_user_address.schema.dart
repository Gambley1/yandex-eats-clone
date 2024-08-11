// ignore_for_file: annotate_overrides

part of 'db_user_address.dart';

extension DbUserAddressRepositories on Session {
  DBUserAddressRepository get dbuserAddresses =>
      DBUserAddressRepository._(this);
}

abstract class DBUserAddressRepository
    implements
        ModelRepository,
        ModelRepositoryInsert<DBUserAddressInsertRequest>,
        ModelRepositoryUpdate<DBUserAddressUpdateRequest>,
        ModelRepositoryDelete<double> {
  factory DBUserAddressRepository._(Session db) = _DBUserAddressRepository;

  Future<DbuserAddressView?> queryDbuserAddress(double latitude);
  Future<List<DbuserAddressView>> queryDbuserAddresses([QueryParams? params]);
}

class _DBUserAddressRepository extends BaseRepository
    with
        RepositoryInsertMixin<DBUserAddressInsertRequest>,
        RepositoryUpdateMixin<DBUserAddressUpdateRequest>,
        RepositoryDeleteMixin<double>
    implements DBUserAddressRepository {
  _DBUserAddressRepository(super.db)
      : super(tableName: 'Address', keyName: 'latitude');

  @override
  Future<DbuserAddressView?> queryDbuserAddress(double latitude) {
    return queryOne(latitude, DbuserAddressViewQueryable());
  }

  @override
  Future<List<DbuserAddressView>> queryDbuserAddresses([QueryParams? params]) {
    return queryMany(DbuserAddressViewQueryable(), params);
  }

  @override
  Future<void> insert(List<DBUserAddressInsertRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.execute(
      Sql.named('INSERT INTO "Address" ( "latitude", "longitude" )\n'
          'VALUES ${requests.map((r) => '( ${values.add(r.latitude)}:float8, ${values.add(r.longitude)}:float8 )').join(', ')}\n'),
      parameters: values.values,
    );
  }

  @override
  Future<void> update(List<DBUserAddressUpdateRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.execute(
      Sql.named('UPDATE "Address"\n'
          'SET "longitude" = COALESCE(UPDATED."longitude", "Address"."longitude")\n'
          'FROM ( VALUES ${requests.map((r) => '( ${values.add(r.latitude)}:float8::float8, ${values.add(r.longitude)}:float8::float8 )').join(', ')} )\n'
          'AS UPDATED("latitude", "longitude")\n'
          'WHERE "Address"."latitude" = UPDATED."latitude"'),
      parameters: values.values,
    );
  }
}

class DBUserAddressInsertRequest {
  DBUserAddressInsertRequest({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;
}

class DBUserAddressUpdateRequest {
  DBUserAddressUpdateRequest({
    required this.latitude,
    this.longitude,
  });

  final double latitude;
  final double? longitude;
}

class DbuserAddressViewQueryable
    extends KeyedViewQueryable<DbuserAddressView, double> {
  @override
  String get keyName => 'latitude';

  @override
  String encodeKey(double key) => TextEncoder.i.encode(key);

  @override
  String get query => 'SELECT "Address".*'
      'FROM "Address"';

  @override
  String get tableAlias => 'Address';

  @override
  DbuserAddressView decode(TypedMap map) => DbuserAddressView(
      latitude: map.get('latitude'), longitude: map.get('longitude'));
}

class DbuserAddressView {
  DbuserAddressView({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;
}
