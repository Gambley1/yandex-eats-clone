import 'package:dart_frog/dart_frog.dart';
import 'package:stormberry/stormberry.dart';
import 'package:yandex_food_api/src/common/common.dart';
import 'package:yandex_food_api/src/common/config/env.internal.dart';

/// Provides context with postgreSQL db [Connection] instance.
///
/// ### Usage
/// final db = context.futureRead<Connection>();
Middleware databaseProvider() {
  final env = EnvInternal();
  final endpoint = Endpoint(
    host: env.pgHost,
    port: env.pgPort.intParse(),
    database: env.pgDatabase,
    username: env.pgUser,
    password: env.pgPassword,
  );
  var connection = Connection.open(endpoint);
  return (handler) {
    return handler.use(
      provider<Future<Connection>>((_) async {
        final conn = await connection;
        if (!conn.isOpen) {
          await conn.close();
          return connection = Connection.open(endpoint);
        }
        return conn;
      }),
    );
  };
}
