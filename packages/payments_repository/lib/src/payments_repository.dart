// ignore_for_file: public_member_api_docs

import 'package:stripe_payments_client/stripe_payments_client.dart';
import 'package:yandex_food_api/client.dart';

/// {@template payments_exception}
/// Exceptions from payments repository.
/// {@endtemplate}
abstract class PaymentsException implements Exception {
  /// {@macro payments_exception}
  const PaymentsException(this.error);

  /// The error which was caught.
  final Object error;

  @override
  String toString() => 'Payments exception error: $error';
}

/// {@template get_credit_cards_failure}
/// Thrown when fetching credit cards fails.
/// {@endtemplate}
class GetCreditCardsFailure extends PaymentsException {
  /// {@macro get_credit_cards_failure}
  const GetCreditCardsFailure(super.error);
}

/// {@template get_credit_cards_failure}
/// Thrown when adding credit card fails.
/// {@endtemplate}
class AddCreditCardFailure extends PaymentsException {
  /// {@macro get_credit_cards_failure}
  const AddCreditCardFailure(super.error);
}

/// {@template delete_credit_card_failure}
/// Thrown when deleting credit card fails.
/// {@endtemplate}
class DeleteCreditCardFailure extends PaymentsException {
  /// {@macro delete_credit_card_failure}
  const DeleteCreditCardFailure(super.error);
}

/// {@template payments_repository}
/// A repository that manages payments data flow.
/// {@endtemplate}
class PaymentsRepository {
  /// {@macro payments_repository}
  const PaymentsRepository({
    required YandexEatsApiClient apiClient,
    required StripePaymentsClient paymentsClient,
  })  : _apiClient = apiClient,
        _paymentsClient = paymentsClient;

  final StripePaymentsClient _paymentsClient;
  final YandexEatsApiClient _apiClient;

  Future<List<CreditCard>> getCreditCards() async {
    try {
      return _apiClient.getCreditCards();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetCreditCardsFailure(error), stackTrace);
    }
  }

  Future<CreditCard> addCreditCard(CreditCard card) async {
    try {
      return _apiClient.addCreditCard(
        cvv: card.cvv,
        number: card.number,
        expiryDate: card.expiryDate,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(AddCreditCardFailure(error), stackTrace);
    }
  }

  Future<void> deleteCreditCard(String number) async {
    try {
      return _apiClient.deleteCreditCard(number: number);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(DeleteCreditCardFailure(error), stackTrace);
    }
  }

  Future<Map<String, dynamic>> callNoWebhookPayEndpointIntentId({
    required String paymentIntentId,
  }) =>
      _paymentsClient.callNoWebhookPayEndpointIntentId(
        paymentIntentId: paymentIntentId,
      );

  Future<Map<String, dynamic>> callNoWebhookPayEndpointMethodId({
    required bool useStripeSdk,
    required String paymentMethodId,
    required String currency,
    required List<String> items,
  }) =>
      _paymentsClient.callNoWebhookPayEndpointMethodId(
        useStripeSdk: useStripeSdk,
        paymentMethodId: paymentMethodId,
        currency: currency,
        items: items,
      );
}
