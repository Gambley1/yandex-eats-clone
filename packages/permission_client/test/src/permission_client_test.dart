// ignore_for_file: prefer_const_constructors
import 'package:permission_client/permission_client.dart';
import 'package:test/test.dart';

void main() {
  group('PermissionClient', () {
    test('can be instantiated', () {
      expect(PermissionClient(), isNotNull);
    });
  });
}
