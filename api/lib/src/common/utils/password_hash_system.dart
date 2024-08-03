import 'package:bcrypt/bcrypt.dart';

/// Password Has System
class PasswordHashSystem {
  /// Password Hash mechanism using ['password_hash_plus'] library
  static String hash(String password) {
    final salt = BCrypt.gensalt();
    return BCrypt.hashpw(password, salt);
  }

  /// Verify two password hashed and return match result
  static bool verify(String password, String dbPassword) {
    return BCrypt.checkpw(password, dbPassword);
  }
}
