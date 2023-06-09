// class EmptySearchResultException implements Exception {}

// class UserAuthenticationRequiredException implements Exception {}

// class InvalidCredentialsException implements Exception {}

// class UsernameAlreadyTakenException implements Exception {}

// class EmailAlreadyRegisteredException implements Exception {}

// class UserNotFoundException implements Exception {}

import 'dart:async';

import 'package:papa_burger/src/restaurant.dart' show logger;
import 'package:papa_burger_server/api.dart' as server;

abstract class ExceptionMessage implements Exception {
  const ExceptionMessage(this.message);

  final String message;
}

/// Assosiated exception for create credit card invalid credentials
class NoSuchRestaurantException implements ExceptionMessage {
  /// {@macro credit_card_invalid_credentials_exception}
  NoSuchRestaurantException(this.error);

  final String error;

  @override
  String get message => error;
}

/// Assosiated exception for create credit card invalid credentials
class NetworkException implements ExceptionMessage {
  /// {@macro credit_card_invalid_credentials_exception}
  NetworkException(this.error);

  final String error;

  @override
  String get message => error;
}

/// Assosiated exception for create credit card invalid credentials
class CreditCardInvalidCredentialsException implements ExceptionMessage {
  /// {@macro credit_card_invalid_credentials_exception}
  CreditCardInvalidCredentialsException(this.error);

  final String error;

  @override
  String get message => error;
}

/// Assosiated exception for create credit card invalid credentials
class CreditCardAlreadyExistsException implements ExceptionMessage {
  /// {@macro credit_card_already_exists_exception}
  const CreditCardAlreadyExistsException(this.error);

  final String error;

  @override
  String get message => error;
}

/// Assosiated exception for credit cards not found
class CreditCardsNotFoundException implements ExceptionMessage {
  /// {@macro credit_cards_not_found_exception}
  const CreditCardsNotFoundException(this.error);

  final String error;

  @override
  String get message => error;
}

/// Assosiated exception for credit card not found
class CreditCardNotFoundException implements ExceptionMessage {
  /// {@macro credit_card_not_found_exception}
  const CreditCardNotFoundException(this.error);

  final String error;

  @override
  String get message => error;
}

/// Assosiated exception for invalid user id
class InvalidUserIdException implements ExceptionMessage {
  /// {@macro invalid_user_id_exception}
  const InvalidUserIdException(this.error);

  final String error;

  @override
  String get message => error;
}

/// Assosiated exception for invalid user id
class ClientRequestFailed implements ExceptionMessage {
  /// {@macro invalid_user_id_exception}
  const ClientRequestFailed({required this.body, this.statusCode});

  final Map<String, dynamic> body;
  final int? statusCode;

  @override
  String get message => body['error'] as String;
}

/// Assosiated exception for invalid user id
class MalformedClientResponse implements ExceptionMessage {
  /// {@macro invalid_user_id_exception}
  const MalformedClientResponse(this.error);

  final String error;

  @override
  String get message => error;
}

/// Assosiated exception for invalid user id
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

/// Assosiated exception for invalid user id
class OrderDetailsNotFoundException implements ExceptionMessage {
  /// {@macro order_details_not_found_exception}
  const OrderDetailsNotFoundException(this.error);

  final String error;

  @override
  String get message => error;
}

/// Assosiated exception for invalid user id
class InvalidAddMenuItemsParametersException implements ExceptionMessage {
  /// {@macro invalid_add_menu_items_parameters_exception}
  const InvalidAddMenuItemsParametersException(this.error);

  final String error;

  @override
  String get message => error;
}

/// Assosiated exception for invalid user id
class InvalidCreateUserOrderParametersException implements ExceptionMessage {
  /// {@macro invalid_user_order_parameters_exception}
  const InvalidCreateUserOrderParametersException(this.error);

  final String error;

  @override
  String get message => error;
}

/// Assosiated exception for invalid user id
class InvalidUpdateUserOrderParametersException implements ExceptionMessage {
  /// {@macro invalid_update_user_order_parameters_exception}
  const InvalidUpdateUserOrderParametersException(this.error);

  final String error;

  @override
  String get message => error;
}

Exception apiExceptionsFormatter(Object e) {
  logger.e(e);
  if (e is TimeoutException) {
    return ClientTimeoutException(
      e.message,
      duration: e.duration,
    );
  }
  if (e is server.NetworkApiException) {
    return NetworkException(e.message);
  }
  if (e is server.ApiClientMalformedResponse) {
    return MalformedClientResponse(e.error.toString());
  }
  if (e is server.ApiClientRequestFailure) {
    logger.e(e.body);
    return ClientRequestFailed(body: e.body, statusCode: e.statusCode);
  }
  if (e is server.CreditCardAlreadyExistsApiException) {
    return CreditCardAlreadyExistsException(e.message);
  }
  if (e is server.CreditCardInvalidCredentialsApiException) {
    return CreditCardInvalidCredentialsException(e.message);
  }
  if (e is server.CreditCardNotFoundApiException) {
    return CreditCardNotFoundException(e.message);
  }
  if (e is server.CreditCardsNotFoundApiException) {
    return CreditCardsNotFoundException(e.message);
  }
  if (e is server.InvalidUserIdApiException) {
    return InvalidUserIdException(e.message);
  }
  if (e is server.OrderDetailsNotFoundApiException) {
    return OrderDetailsNotFoundException(e.message);
  }
  if (e is server.InvalidAddMenuItemsParametersApiException) {
    return InvalidAddMenuItemsParametersException(e.message);
  }
  if (e is server.InvalidCreateUserOrderParametersApiException) {
    logger.e(e.message);
    return InvalidCreateUserOrderParametersException(e.message);
  }
  if (e is server.InvalidUpdateUserOrderParametersApiException) {
    return InvalidUpdateUserOrderParametersException(e.message);
  }
  return const MalformedClientResponse('Something went wrong');
}
