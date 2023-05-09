import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:papa_burger/src/restaurant.dart' show logger;

class TestProvider extends ChangeNotifier {
  TestProvider() {
    logger.w('Inits Test Provider state Class');
  }
}
