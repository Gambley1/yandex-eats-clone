import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/restaurant.dart' show User;

@immutable
abstract class BaseUserRepository {
  Future<User> login(String email, String password);
  Future<User> register(
    String name,
    String email,
    String password,
  );
  Future<void> logout();
}
