import 'package:flutter/foundation.dart' show immutable;
import 'package:shared/shared.dart';

@immutable
abstract class BaseUserRepository {
  Future<User> login(String email, String password);
  Future<User> signUp(String name, String email, String password);
  Future<void> logout();
}
