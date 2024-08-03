import 'package:dart_frog/dart_frog.dart';
import 'package:stormberry/stormberry.dart';
import 'package:yandex_food_api/src/common/common.dart';

Future<Connection>? _connection;

/// Provides context with postgreSQL db [Connection] instance.
///
/// ### Usage
/// final db = context.futureRead<Connection>();
Middleware databaseProvider() {
  final env = Env();
  final endpoint = Endpoint(
    host: env.pgHost,
    port: env.pgPort.intParse(),
    database: env.pgDatabase,
    username: env.pgUser,
    password: env.pgPassword,
  );
  _connection ??= Connection.open(endpoint);
  return (handler) {
    return handler.use(
      provider<Future<Connection>>((_) async {
        final conn = await _connection;
        if (!(conn?.isOpen ?? false) || conn == null) {
          await conn?.close();
          _connection = null;
          return _connection = Connection.open(endpoint);
        }
        return conn;
      }),
    );
  };
}
