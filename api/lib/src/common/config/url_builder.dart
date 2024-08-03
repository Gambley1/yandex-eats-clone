/// Url builder for Yandex Food API client.
class UrlBuilder {
  const UrlBuilder({required String baseUrl}) : _baseUrl = baseUrl;

  final String _baseUrl;

  /// Build parse url for getting restaurant by place id
  Uri getRestaurant({
    required String id,
    String? latitude,
    String? longitude,
  }) =>
      Uri.parse('$_baseUrl/restaurants/$id').replace(
        queryParameters: {
          if (latitude != null) 'lat': latitude,
          if (longitude != null) 'lng': longitude,
        },
      );

  /// Build parse url for restaurants by location
  Uri getRestaurants({
    required String latitude,
    required String longitude,
    String? limit,
    String? offset,
  }) {
    return Uri.parse(
      '$_baseUrl/restaurants',
    ).replace(
      queryParameters: {
        'lat': latitude,
        'lng': longitude,
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
      },
    );
  }

  /// Build parse url for restaurants by tags.
  Uri getRestaurantsByTags({
    required String latitude,
    required String longitude,
    String? limit,
    String? offset,
  }) {
    return Uri.parse(
      '$_baseUrl/search/by-tags',
    ).replace(
      queryParameters: {
        'lat': latitude,
        'lng': longitude,
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
      },
    );
  }

  /// Build parse url for popular restaurants.
  Uri getTags({
    required String latitude,
    required String longitude,
    String? limit,
    String? offset,
  }) {
    return Uri.parse(
      '$_baseUrl/tags',
    ).replace(
      queryParameters: {
        'lat': latitude,
        'lng': longitude,
      },
    );
  }

  /// Build parse url for all restaurants
  Uri popularRestaurants({
    required String latitude,
    required String longitude,
  }) {
    return Uri.parse(
      '$_baseUrl/search/popular',
    ).replace(
      queryParameters: {
        'lat': latitude,
        'lng': longitude,
      },
    );
  }

  /// Build parse url for all restaurants
  Uri relevantRestaurants({
    required String latitude,
    required String longitude,
    required String term,
  }) {
    return Uri.parse(
      '$_baseUrl/search/relevant',
    ).replace(
      queryParameters: {
        'lat': latitude,
        'lng': longitude,
        'q': term,
      },
    );
  }

  /// Build parse url for all restaurants for admin panel
  Uri buildAdminRestaurantsUrl({
    required String method,
    String? placeId,
    String? name,
    String? tags,
    String? imageUrl,
    String? rating,
    String? userRatingsTotal,
    String? latitude,
    String? longitude,
  }) {
    final noQueryParameters = placeId == null &&
        name == null &&
        tags == null &&
        imageUrl == null &&
        rating == null &&
        userRatingsTotal == null &&
        latitude == null &&
        longitude == null;

    return Uri.parse('$_baseUrl/restaurants').replace(
      queryParameters: noQueryParameters
          ? null
          : {
              if (placeId != null) 'place_id': placeId,
              if (name != null) 'name': name,
              if (tags != null) 'tags': tags,
              if (imageUrl != null) 'image_url': imageUrl,
              if (userRatingsTotal != null)
                'user_ratings_total': userRatingsTotal,
              if (latitude != null) 'latitude': latitude,
              if (longitude != null) 'longitude': longitude,
              if (rating != null) 'rating': rating,
            },
    );
  }

  /// Build parse url for restaurants menu by place id
  Uri buildRestaurantsMenuUrl(String placeId) =>
      Uri.parse('$_baseUrl/restaurants/$placeId/menu');

  /// Build parse url for user login
  Uri get buildUserLoginUrl => Uri.parse('$_baseUrl/login');

  /// Build parse url for user login
  Uri get buildUserRegisterUrl => Uri.parse('$_baseUrl/sign_up');

  /// Build http url for user profile
  Uri getCurrentUser() => Uri.parse('$_baseUrl/user/me');

  Uri getCreditCards() => Uri.parse('$_baseUrl/cards');

  Uri addCreditCard({required String number}) =>
      Uri.parse('$_baseUrl/cards/$number');

  Uri deleteCreditCard({required String number}) =>
      Uri.parse('$_baseUrl/cards/$number');

  Uri deleteOrder({required String id}) => Uri.parse('$_baseUrl/orders/$id');

  Uri updateOrder({required String id}) {
    return Uri.parse('$_baseUrl/orders/$id');
  }

  Uri getOrder({required String id}) => Uri.parse('$_baseUrl/orders/$id');

  Uri getOrders() => Uri.parse('$_baseUrl/orders');

  Uri createOrder({required String id}) => Uri.parse('$_baseUrl/orders/$id');

  Uri addOrderMenuItem({required String orderId}) =>
      Uri.parse('$_baseUrl/orders/$orderId/items');

  Uri deleteOrderMenuItems({required String orderId}) =>
      Uri.parse('$_baseUrl/orders/$orderId/items');

  /// Build parse url for sending user notification
  Uri sendNotification() => Uri.parse('$_baseUrl/notifications');

  /// Build parse url for getting user notifications
  Uri getNotifications() => Uri.parse('$_baseUrl/notifications');
}
