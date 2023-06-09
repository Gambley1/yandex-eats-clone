import 'package:flutter_dotenv/flutter_dotenv.dart';

class DotEnvConfig {
  DotEnvConfig();

  // static final _env = DotEnv()..load();

  // static final googleApiKey = _env.env['GOOGLE_API_KEY'] ?? '';

  // static final publishStripeKey = _env.env['STRIPE_PUBLISH_KEY'] ?? '';

  static final googleApiKey = dotenv.get('GOOGLE_API_KEY');

  static final publishStripeKey = dotenv.get('STRIPE_PUBLISH_KEY');

  static final secretStripeKey = dotenv.get('STRIPE_SECRET_KEY');
}
