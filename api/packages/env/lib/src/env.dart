import 'package:envied/envied.dart';

part 'env.g.dart';

/// {@template env}
/// Environment variables. Used to access environment variables in the app.
/// {@endtemplate}
@Envied(path: '.env', obfuscate: true)
abstract class Env {
  /// API url secret.
  @EnviedField(varName: 'API_URL', obfuscate: true)
  static String apiUrl = _Env.apiUrl;

  /// Postgres host secret.
  @EnviedField(varName: 'PGHOST', obfuscate: true)
  static String pgHost = _Env.pgHost;

  /// Postgres port secret.
  @EnviedField(varName: 'PGPORT', obfuscate: true)
  static String pgPort = _Env.pgPort;

  /// Postgres database secret.
  @EnviedField(varName: 'PGDATABASE', obfuscate: true)
  static String pgDatabase = _Env.pgDatabase;

  /// Postgres user secret.
  @EnviedField(varName: 'PGUSER', obfuscate: true)
  static String pgUser = _Env.pgUser;

  /// Postgres password secret.
  @EnviedField(varName: 'PGPASSWORD', obfuscate: true)
  static String pgPassword = _Env.pgPassword;

  /// Token config secret.
  @EnviedField(varName: 'TOKEN_CONFIG', obfuscate: true)
  static String tokenConfig = _Env.tokenConfig;

  /// Google maps api key secret.
  @EnviedField(varName: 'GOOGLE_MAPS_API_KEY', obfuscate: true)
  static String googleMapsApiKey = _Env.googleMapsApiKey;

  /// Stripe publish key secret.
  @EnviedField(varName: 'STRIPE_PUBLISH_KEY', obfuscate: true)
  static String stirpePublishKey = _Env.stirpePublishKey;

  /// Stripe secret key secret.
  @EnviedField(varName: 'STRIPE_SECRET_KEY', obfuscate: true)
  static String stripeSecretKey = _Env.stripeSecretKey;
}
