import 'package:envied/envied.dart';

part 'env.g.dart';

/// {@template env}
/// Environment variables. Used to access environment variables in the app.
/// {@endtemplate}
@Envied(path: '.env', obfuscate: true)
abstract class Env {
  /// Google maps api key secret.
  @EnviedField(varName: 'GOOGLE_MAPS_API_KEY', obfuscate: true)
  static String googleMapsApiKey = _Env.googleMapsApiKey;

  /// Stripe publish key secret.
  @EnviedField(varName: 'STRIPE_PUBLISH_KEY', obfuscate: true)
  static String stripePublishKey = _Env.stripePublishKey;

  /// Stripe secret key secret.
  @EnviedField(varName: 'STRIPE_SECRET_KEY', obfuscate: true)
  static String stripeSecretKey = _Env.stripeSecretKey;
}
