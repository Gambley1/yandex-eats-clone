import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class BaseUserRepository {
  // void logIn(String email, String password);
  // void googleLogIn();
  void logout();
  Future<void> logIn(String email, String password);
  void register(String email, String password);
}
