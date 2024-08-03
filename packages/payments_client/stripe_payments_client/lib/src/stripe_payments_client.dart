import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:yandex_food_api/client.dart';

/// {@template stripe_payments_client}
/// Payments client based on Stripe.
/// {@endtemplate}
class StripePaymentsClient {
  /// {@macro stripe_payments_client}
  const StripePaymentsClient({required AppDio appDio}) : _appDio = appDio;

  static final _kApiUrl = defaultTargetPlatform == TargetPlatform.android
      ? 'http://10.0.2.2:4242'
      : 'http://localhost:4242';

  final AppDio _appDio;

  /// Calls the endpoint that creates a payment intent.
  Future<Map<String, dynamic>> callNoWebhookPayEndpointIntentId({
    required String paymentIntentId,
  }) async {
    final url = Uri.parse('$_kApiUrl/charge-card-off-session');
    final response = await _appDio.httpClient.postUri<Map<String, dynamic>>(
      url,
      data: json.encode({'paymentIntentId': paymentIntentId}),
    );
    return response.data!;
  }

  /// Calls no webhook pay endpoint with payment method id.
  Future<Map<String, dynamic>> callNoWebhookPayEndpointMethodId({
    required bool useStripeSdk,
    required String paymentMethodId,
    required String currency,
    required List<String> items,
  }) async {
    final url = Uri.parse('$_kApiUrl/pay-without-webhooks');
    final response = await _appDio.httpClient.postUri<Map<String, dynamic>>(
      url,
      data: json.encode({
        'useStripeSdk': useStripeSdk,
        'paymentMethodId': paymentMethodId,
        'currency': currency,
        'items': items,
      }),
    );
    return response.data!;
  }
}
