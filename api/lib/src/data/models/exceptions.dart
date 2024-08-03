/// Associated message for occured exception
abstract class ExceptionMessage implements Exception {
  /// {@macro exception_message}
  const ExceptionMessage(this.message);

  /// Associated message for exception
  final String message;
}

/// Associated exception for create credit card invalid credentials
class NetworkApiException implements ExceptionMessage {
  /// {@macro credit_card_invalid_credentials_exception}
  NetworkApiException();

  @override
  String get message => 'Network connection failed. Try reconnect you wifi.';
}

/// Assosited exception for already regisered email
class EmailAlreadyRegisteredApiException implements ExceptionMessage {
  /// {@macro email_already_registered_api_exception}
  const EmailAlreadyRegisteredApiException();

  @override
  String get message => 'Email already registered.';
}

/// Associated exception for user invalid credentials
class InvalidCredentialsApiException implements ExceptionMessage {
  /// {@macro invalid_credentials_api_exception}
  const InvalidCredentialsApiException();

  @override
  String get message => 'Invalid user credentials.';
}

/// Associated exception for not found user
class UserNotFoundApiException implements ExceptionMessage {
  /// {@macro user_not_found_api_exception}
  const UserNotFoundApiException();

  @override
  String get message => 'User with this email not found.';
}

/// Associated exception for JWT expired time
class TokenExpiredApiException implements ExceptionMessage {
  /// {@macro token_expired_api_exception}
  const TokenExpiredApiException();

  @override
  String get message => 'Token has expired.';
}

/// Associated exception for create credit card invalid credentials
class CreditCardInvalidCredentialsApiException implements ExceptionMessage {
  /// {@macro credit_card_invalid_credentials_api_exception}
  const CreditCardInvalidCredentialsApiException();

  @override
  String get message => 'Invalid credentials.';
}

/// Associated exception for create credit card invalid credentials
class CreditCardAlreadyExistsApiException implements ExceptionMessage {
  /// {@macro credit_card_already_exists_api_exception}
  const CreditCardAlreadyExistsApiException();

  @override
  String get message => 'Credit card with this number already exists!';
}

/// Associated exception for credit cards not found
class CreditCardsNotFoundApiException implements ExceptionMessage {
  /// {@macro credit_cards_not_found_api_exception}
  const CreditCardsNotFoundApiException();

  @override
  String get message => 'Credit cards not found.';
}

/// Associated exception for credit card not found
class CreditCardNotFoundApiException implements ExceptionMessage {
  /// {@macro credit_card_not_found_api_exception}
  const CreditCardNotFoundApiException();

  @override
  String get message => "Couldn't find credit card by this number.";
}

/// Associated exception for invalid user id
class InvalidUserIdApiException implements ExceptionMessage {
  /// {@macro invalid_user_id_api_exception}
  const InvalidUserIdApiException();

  @override
  String get message => 'User id is not valid.';
}

/// Associated exception for invalid user id
class OrderDetailsNotFoundApiException implements ExceptionMessage {
  /// {@macro order_details_not_found_api_exception}
  const OrderDetailsNotFoundApiException();

  @override
  String get message => 'Order details are not found.';
}

/// Associated exception for invalid user id
class InvalidAddMenuItemsParametersApiException implements ExceptionMessage {
  /// {@macro invalid_add_menu_items_parameters_api_exception}
  const InvalidAddMenuItemsParametersApiException();

  @override
  String get message => 'Invalid parameters. All fields are required.';
}

/// Associated exception for invalid user id
class InvalidCreateUserOrderParametersApiException implements ExceptionMessage {
  /// {@macro invalid_user_order_parameters_api_exception}
  const InvalidCreateUserOrderParametersApiException();

  @override
  String get message => 'Invalid parameters. All fields are required.';
}

/// Associated exception for invalid user id
class InvalidUpdateUserOrderParametersApiException implements ExceptionMessage {
  /// {@macro invalid_update_user_order_parameters_api_exception}
  const InvalidUpdateUserOrderParametersApiException();

  @override
  String get message => 'Invalid parameters. All fields are required.';
}

/// Associated exception for invalid user id
class AddRestaurantInvalidParametersApiException implements ExceptionMessage {
  /// {@macro add_restaurant_invalid_parameters_api_exception}
  const AddRestaurantInvalidParametersApiException(this.missingFields);

  /// Associated missing fields for invalid parameters api exception
  final dynamic missingFields;

  @override
  String get message => 'Invalid parameters. $missingFields';
}

/// Associated exception for invalid user id
class UpdateRestaurantInvalidParametersApiException
    implements ExceptionMessage {
  /// {@macro update_restaurant_invalid_parameters_api_exception}
  const UpdateRestaurantInvalidParametersApiException(this.missingFields);

  /// Associated missing fields for invalid parameters api exception
  final dynamic missingFields;

  @override
  String get message => 'Invalid parameters. $missingFields';
}

/// Associated exception for invalid user id
class DeleteRestaurantInvalidParametersApiException
    implements ExceptionMessage {
  /// {@macro delete_restaurant_invalid_parameters_api_exception}
  const DeleteRestaurantInvalidParametersApiException(this.missingFields);

  /// Associated missing fields for invalid parameters api exception
  final dynamic missingFields;

  @override
  String get message => 'Invalid parameters. $missingFields';
}

/// Associated exception for invalid user id
class NoRestaurantsFoundApiException implements ExceptionMessage {
  /// {@macro no_restaurants_found_api_exception}
  const NoRestaurantsFoundApiException();

  @override
  String get message => "Couldn't find any restaurants.";
}

/// Associated exception
class NoUserNotificationsFoundApiException implements ExceptionMessage {
  /// {@macro no_user_notifications_found_api_exception}
  const NoUserNotificationsFoundApiException();

  @override
  String get message => "Couldn't find any user notifications.";
}

/// Associated exception
class GetListUserNotificationsMissingUidApiException
    implements ExceptionMessage {
  /// {@macro get_list_user_notifications_missing_uid_api_exception}
  const GetListUserNotificationsMissingUidApiException(this.missingFields);

  /// Associated missing fields for this api exception
  final dynamic missingFields;

  @override
  String get message => 'Invalid parameters. $missingFields';
}

/// Associated exception for invalid user id
class SendUserNotificationInvalidParametersApiException
    implements ExceptionMessage {
  /// {@macro send_user_notification_invalid_parameters_api_exception}
  const SendUserNotificationInvalidParametersApiException(this.missingFields);

  /// Associated missing fields for invalid parameters api exception
  final dynamic missingFields;

  @override
  String get message => 'Invalid parameters. $missingFields';
}

/// Associated exception for invalid user id
class NoRestaurantFoundByPlaceIdApiException implements ExceptionMessage {
  /// {@macro no_restaurant_found_by_place_id_api_exception}
  const NoRestaurantFoundByPlaceIdApiException();

  @override
  String get message => "Couldn't find restaurant by place id.";
}
