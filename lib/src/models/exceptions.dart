import 'dart:async';

import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger_server/api.dart' as server;

abstract class ExceptionMessage implements Exception {
  const ExceptionMessage(this.message);

  final String message;
}

/// Associated exception for create credit card invalid credentials
class NoSuchRestaurantException implements ExceptionMessage {
  /// {@macro credit_card_invalid_credentials_exception}
  NoSuchRestaurantException(this.error);

  final String error;

  @override
  String get message => error;
}

/// Associated exception for create credit card invalid credentials
class NetworkException implements ExceptionMessage {
  /// {@macro credit_card_invalid_credentials_exception}
  NetworkException(this.error);

  final String error;

  @override
  String get message => error;
}

/// Associated exception for create credit card invalid credentials
class CreditCardInvalidCredentialsException implements ExceptionMessage {
  /// {@macro credit_card_invalid_credentials_exception}
  CreditCardInvalidCredentialsException(this.error);

  final String error;

  @override
  String get message => error;
}

/// Associated exception for create credit card invalid credentials
class CreditCardAlreadyExistsException implements ExceptionMessage {
  /// {@macro credit_card_already_exists_exception}
  const CreditCardAlreadyExistsException(this.error);

  final String error;

  @override
  String get message => error;
}

/// Associated exception for credit cards not found
class CreditCardsNotFoundException implements ExceptionMessage {
  /// {@macro credit_cards_not_found_exception}
  const CreditCardsNotFoundException(this.error);

  final String error;

  @override
  String get message => error;
}

/// Associated exception for credit card not found
class CreditCardNotFoundException implements ExceptionMessage {
  /// {@macro credit_card_not_found_exception}
  const CreditCardNotFoundException(this.error);

  final String error;

  @override
  String get message => error;
}

/// Associated exception for invalid user id
class InvalidUserIdException implements ExceptionMessage {
  /// {@macro invalid_user_id_exception}
  const InvalidUserIdException(this.error);

  final String error;

  @override
  String get message => error;
}

/// Associated exception for invalid user id
class ClientRequestFailed implements ExceptionMessage {
  /// {@macro invalid_user_id_exception}
  const ClientRequestFailed({required this.body, this.statusCode});

  final Map<String, dynamic> body;
  final int? statusCode;

  @override
  String get message => body['error'] as String;
}

/// Associated exception for invalid user id
class MalformedClientResponse implements ExceptionMessage {
  /// {@macro invalid_user_id_exception}
  const MalformedClientResponse(this.error);

  final String error;

  @override
  String get message => error;
}

/// Associated exception for invalid user id
class ClientTimeoutException implements ExceptionMessage {
  /// {@macro client_timeout_exception}
  const ClientTimeoutException(
    this.error, {
    this.duration,
  });

  final Duration? duration;
  final String? error;

  @override
  String get message => error ?? 'Client ran out of time.';
}

/// Associated exception for invalid user id
class OrderDetailsNotFoundException implements ExceptionMessage {
  /// {@macro order_details_not_found_exception}
  const OrderDetailsNotFoundException(this.error);

  final String error;

  @override
  String get message => error;
}

/// Associated exception for invalid user id
class InvalidAddMenuItemsParametersException implements ExceptionMessage {
  /// {@macro invalid_add_menu_items_parameters_exception}
  const InvalidAddMenuItemsParametersException(this.error);

  final String error;

  @override
  String get message => error;
}

/// Associated exception for invalid user id
class InvalidCreateUserOrderParametersException implements ExceptionMessage {
  /// {@macro invalid_user_order_parameters_exception}
  const InvalidCreateUserOrderParametersException(this.error);

  final String error;

  @override
  String get message => error;
}

/// Associated exception for invalid user id
class InvalidUpdateUserOrderParametersException implements ExceptionMessage {
  /// {@macro invalid_update_user_order_parameters_exception}
  const InvalidUpdateUserOrderParametersException(this.error);

  final String error;

  @override
  String get message => error;
}

/// Associated exception for invalid user id
class AddRestaurantInvalidParametersException implements ExceptionMessage {
  /// {@macro add_restaurant_invalid_parameters_exception}
  const AddRestaurantInvalidParametersException(this.error);

  final String error;

  @override
  String get message => error;
}

/// Associated exception for invalid user id
class UpdateRestaurantInvalidParametersException implements ExceptionMessage {
  /// {@macro update_restaurant_invalid_parameters_exception}
  const UpdateRestaurantInvalidParametersException(this.error);

  final String error;

  @override
  String get message => error;
}

/// Associated exception for invalid user id
class DeleteRestaurantInvalidParametersException implements ExceptionMessage {
  /// {@macro delete_restaurant_invalid_parameters_exception}
  const DeleteRestaurantInvalidParametersException(this.error);

  final String error;

  @override
  String get message => error;
}

/// Associated exception for invalid user id
class NoRestaurantsFoundException implements ExceptionMessage {
  /// {@macro no_restaurants_found_exception}
  const NoRestaurantsFoundException(this.error);

  final String error;

  @override
  String get message => error;
}

Exception apiExceptionsFormatter(Object error, StackTrace stackTrace) {
  logE('API Request Failed.', error: error, stackTrace: stackTrace);
  return switch (error) {
    final TimeoutException e => ClientTimeoutException(
        e.message,
        duration: e.duration,
      ),
    final server.NetworkApiException e => NetworkException(e.message),
    final server.ApiClientMalformedResponse e =>
      MalformedClientResponse(e.error.toString()),
    final server.ApiClientRequestFailure e =>
      ClientRequestFailed(body: e.body, statusCode: e.statusCode),
    final server.CreditCardAlreadyExistsApiException e =>
      CreditCardAlreadyExistsException(e.message),
    final server.CreditCardInvalidCredentialsApiException e =>
      CreditCardInvalidCredentialsException(e.message),
    final server.CreditCardNotFoundApiException e =>
      CreditCardNotFoundException(e.message),
    final server.CreditCardsNotFoundApiException e =>
      CreditCardsNotFoundException(e.message),
    final server.InvalidUserIdApiException e =>
      InvalidUserIdException(e.message),
    final server.OrderDetailsNotFoundApiException e =>
      OrderDetailsNotFoundException(e.message),
    final server.InvalidAddMenuItemsParametersApiException e =>
      InvalidAddMenuItemsParametersException(e.message),
    final server.InvalidCreateUserOrderParametersApiException e =>
      InvalidCreateUserOrderParametersException(e.message),
    final server.InvalidUpdateUserOrderParametersApiException e =>
      InvalidUpdateUserOrderParametersException(e.message),
    final server.AddRestaurantInvalidParametersApiException e =>
      AddRestaurantInvalidParametersException(e.message),
    final server.UpdateRestaurantInvalidParametersApiException e =>
      UpdateRestaurantInvalidParametersException(e.message),
    final server.DeleteRestaurantInvalidParametersApiException e =>
      DeleteRestaurantInvalidParametersException(e.message),
    final server.NoRestaurantsFoundApiException e =>
      NoRestaurantsFoundException(e.message),
    _ => const MalformedClientResponse('Something went wrong!'),
  };
}
