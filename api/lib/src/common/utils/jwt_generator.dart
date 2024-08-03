// ignore_for_file: lines_longer_than_80_chars

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

/// JWT generator
class JWTUtils {
  /// Generate random JWT token
  static String generateJwt(
    String subject,
    String issuer,
    String secret, {
    String? jwtId,
    Duration expiry = const Duration(seconds: 30),
  }) {
    final jwt = JWT(
      {
        'iat': DateTime.now().millisecondsSinceEpoch,
      },
      subject: subject,
      issuer: issuer,
      jwtId: jwtId,
    );
    return jwt.sign(SecretKey(secret), expiresIn: expiry);
  }
}
