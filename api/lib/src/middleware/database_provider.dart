import 'package:dart_frog/dart_frog.dart';
import 'package:stormberry/stormberry.dart';
import 'package:yandex_food_api/src/common/common.dart';

/// Provides context with postgreSQL db [Connection] instance.
///
/// ### Usage
/// final db = context.futureRead<Connection>();
Middleware databaseProvider() {
  final endpoint = Endpoint(
    host: Env.pgHost,
    port: Env.pgPort.intParse(),
    database: Env.pgDatabase,
    username: Env.pgUser,
    password: Env.pgPassword,
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
