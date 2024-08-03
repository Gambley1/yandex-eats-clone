// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stripe_payments_client/stripe_payments_client.dart';
import 'package:yandex_food_api/client.dart';

class MockAppDio extends Mock implements AppDio {}

void main() {
  group('StripePaymentsClient', () {
    late AppDio appDio;

    setUp(() => appDio = MockAppDio());
    test('can be instantiated', () {
      expect(StripePaymentsClient(appDio: appDio), isNotNull);
    });
  });
}
