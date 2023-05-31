import 'package:flutter_dotenv/flutter_dotenv.dart';

class DotEnvConfig {
  DotEnvConfig();

  static final _env = DotEnv()..load();

  static final googleApiKey = _env.env['GOOGLE_API_KEY'] ?? '';
}
