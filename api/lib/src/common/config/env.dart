import 'dart:async';

import 'package:dotenv/dotenv.dart';

/// {@template dotenv_cofig}
/// Dot env internal config.
/// {@endtemplate}
class Env {
  /// {@macro env_internal}
  Env() {
    _initEnv();
  }

  final DotEnv _env = DotEnv(includePlatformEnvironment: true);

  Future<void> _initEnv() async {
    _env.load();
  }

  /// Access secret variable by provided key of data.
  String env(String key) => _env.getOrElse(key, () => '');

  /// Value of secret pg host from environment.
  String get pgHost => env('PGHOST');

  /// Value of secret pg database variable from environment.
  String get pgDatabase => env('PGDATABASE');

  /// Value of secret pg password variable from environment.
  String get pgPassword => env('PGPASSWORD');

  /// Value of secret pg user variable from environment.
  String get pgUser => env('PGUSER');

  /// Value of pg port variable from environment.
  String get pgPort => env('PGPORT');
}
