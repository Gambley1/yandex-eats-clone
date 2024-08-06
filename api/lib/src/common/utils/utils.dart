import 'dart:math';

export 'extensions/extensions.dart';
export 'jwt_generator.dart';
export 'password_hash_system.dart';

String generateOrderId() {
  var counter = 0;
  final timestamp =
      DateTime.now().millisecondsSinceEpoch ~/ 1000; // Shortened timestamp
  final randomDigits =
      Random().nextInt(900) + 100; // Generate a 3-digit random number
  final uniqueId = (timestamp % 100000) * 1000 + randomDigits + counter;
  counter = (counter + 1) % 1000; // Ensure the counter stays within 3 digits
  return uniqueId.toString().padLeft(6, '0');
}
