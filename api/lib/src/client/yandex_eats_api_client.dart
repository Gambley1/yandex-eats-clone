import 'dart:io';

import 'package:dio/dio.dart';
import 'package:yandex_food_api/api.dart';

/// {@template yandex_eats_api_malformed_response}
/// An exception thrown when there is a problem decoded the response body.
/// {@endtemplate}
class YandexEatsApiMalformedResponse implements Exception {
  /// {@macro yandex_eats_api_malformed_response}
  const YandexEatsApiMalformedResponse({required this.error});

  /// The associated error.
  final Object error;
}

/// {@template yandex_eats_api_request_failure}
/// An exception thrown when an http request failure occurs.
/// {@endtemplate}
class YandexEatsApiRequestFailure implements Exception {
  /// {@macro yandex_eats_api_request_failure}
  const YandexEatsApiRequestFailure({
    required this.statusCode,
    required this.body,
  });

  /// The associated http status code.
  final int? statusCode;

  /// The associated response body.
  final Map<String, dynamic> body;
}

/// {@template yandex_eats_api_client}
/// Yandex Eats API client.
/// {@endtemplate}
class YandexEatsApiClient {
  /// {@macro api_client}
  YandexEatsApiClient({
    required AppDio dio,
    required String baseUrl,
  }) : this._(
          dio: dio,
          urlBuilder: UrlBuilder(baseUrl: baseUrl),
        );

  /// {@macro api_client.localhost}
  YandexEatsApiClient.localhost({
    required AppDio dio,
  }) : this._(
          dio: dio,
          urlBuilder: const UrlBuilder(baseUrl: 'http://localhost:8080/api/v1'),
        );

  /// {@macro api_client}
  YandexEatsApiClient._({
    required UrlBuilder urlBuilder,
    required AppDio dio,
  })  : _urlBuilder = urlBuilder,
        _dio = dio;

  final AppDio _dio;
  final UrlBuilder _urlBuilder;

  /// Send user notification
  Future<void> sendNotification({required String message}) async {
    final uri = _urlBuilder.sendNotification();

    final response = await _dio.httpClient.postUri<String>(
      uri,
      data: {'message': message},
    );

    if (!response.isCreated) {
      throw YandexEatsApiRequestFailure(
        body: <String, String>{},
        statusCode: response.statusCode,
      );
    }
  }

  Future<List<Notification>> getNotifications() async {
    final uri = _urlBuilder.getNotifications();
    final response = await _dio.httpClient.getUri<Map<String, dynamic>>(
      uri,
    );
    final data = response.json();

    if (!response.isOk) {
      throw YandexEatsApiRequestFailure(
        body: data,
        statusCode: response.statusCode,
      );
    }

    final notifications = data['notifications'] as List;
    return notifications
        .map<Notification>(
          (e) => Notification.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }

  Future<Restaurant?> getRestaurant({
    required String id,
    Location? location,
  }) async {
    final uri = _urlBuilder.getRestaurant(
      id: id,
      latitude: location?.lat.toString(),
      longitude: location?.lng.toString(),
    );
    final response = await _dio.httpClient.getUri<Map<String, dynamic>>(
      uri,
    );
    final data = response.data;
    if (data == null) return null;

    if (!response.isOk) {
      throw YandexEatsApiRequestFailure(
        body: data,
        statusCode: response.statusCode,
      );
    }

    final restaurant = data['restaurant'] as Map<String, dynamic>;
    return Restaurant.fromJson(restaurant);
  }

  Future<List<Restaurant>> getRestaurants({
    required Location location,
    int? limit,
    int? offset,
  }) async {
    final uri = _urlBuilder.getRestaurants(
      latitude: location.lat.toString(),
      longitude: location.lng.toString(),
      limit: limit?.toString(),
      offset: offset?.toString(),
    );
    final response = await _dio.httpClient.getUri<Map<String, dynamic>>(
      uri,
    );
    final data = response.json();
    if (!response.isOk) {
      throw YandexEatsApiRequestFailure(
        body: data,
        statusCode: response.statusCode,
      );
    }

    final restaurants = data['restaurants'] as List<dynamic>;
    return restaurants
        .map((e) => Restaurant.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> addRestaurant({
    required String id,
    required String name,
    required double rating,
    required int userRatingsTotal,
    required Location location,
    String tags = 'Fast Food',
    String imageUrl = '',
  }) async {
    final uri = _urlBuilder.buildAdminRestaurantsUrl(
      method: 'post',
      name: name,
      rating: '$rating',
      placeId: id,
      userRatingsTotal: '$userRatingsTotal',
      latitude: '${location.lat}',
      longitude: '${location.lng}',
      tags: tags,
      imageUrl: imageUrl,
    );
    final response = await _dio.httpClient.postUri<String>(
      uri,
    );
    if (!response.isCreated) {
      throw YandexEatsApiRequestFailure(
        body: <String, String>{},
        statusCode: response.statusCode,
      );
    }
  }

  Future<void> updateRestaurant({
    required String id,
    String? name,
    double? rating,
    int? userRatingsTotal,
    Location? location,
    String? tags,
    String? imageUrl,
  }) async {
    final uri = _urlBuilder.buildAdminRestaurantsUrl(
      method: 'put',
      name: name,
      rating: '$rating',
      placeId: id,
      userRatingsTotal: '$userRatingsTotal',
      latitude: location?.lat == null ? null : '${location?.lat}',
      longitude: location?.lng == null ? null : '${location?.lng}',
      tags: tags,
      imageUrl: imageUrl,
    );
    final response = await _dio.httpClient.putUri<String>(
      uri,
    );
    if (!response.isCreated) {
      throw YandexEatsApiRequestFailure(
        body: <String, String>{},
        statusCode: response.statusCode,
      );
    }
  }

  Future<void> deleteRestaurant(String placeId) async {
    final uri = _urlBuilder.buildAdminRestaurantsUrl(
      method: 'delete',
      placeId: placeId,
    );
    final response = await _dio.httpClient.deleteUri<String>(
      uri,
    );
    if (!response.isCreated) {
      throw YandexEatsApiRequestFailure(
        body: <String, String>{},
        statusCode: response.statusCode,
      );
    }
  }

  Future<List<Restaurant>> relevantSearch({
    required String term,
    required Location location,
  }) async {
    if (term.isEmpty) return [];
    final uri = _urlBuilder.relevantRestaurants(
      term: term.replaceAllSpacesToLowerCase(),
      latitude: location.lat.toString(),
      longitude: location.lng.toString(),
    );

    final response = await _dio.httpClient.getUri<Map<String, dynamic>>(
      uri,
    );
    final data = response.json();
    if (!response.isOk) {
      throw YandexEatsApiRequestFailure(
        body: data,
        statusCode: response.statusCode,
      );
    }

    final restaurants = data['restaurants'] as List;
    return restaurants
        .map((e) => Restaurant.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Restaurant>> popularSearch({
    required Location location,
  }) async {
    final uri = _urlBuilder.popularRestaurants(
      latitude: location.lat.toString(),
      longitude: location.lng.toString(),
    );

    final response = await _dio.httpClient.getUri<Map<String, dynamic>>(
      uri,
    );
    final data = response.json();
    if (!response.isOk) {
      throw YandexEatsApiRequestFailure(
        body: data,
        statusCode: response.statusCode,
      );
    }

    final restaurants = data['restaurants'] as List;
    return restaurants
        .map((e) => Restaurant.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Tag>> getTags({required Location location}) async {
    final uri = _urlBuilder.getTags(
      latitude: location.lat.toString(),
      longitude: location.lng.toString(),
    );

    final response = await _dio.httpClient.getUri<Map<String, dynamic>>(
      uri,
    );
    final data = response.json();
    if (!response.isOk) {
      throw YandexEatsApiRequestFailure(
        body: data,
        statusCode: response.statusCode,
      );
    }
    final tags = data['tags'] as List;
    return tags.map((e) => Tag.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Restaurant>> getRestaurantsByTags({
    required List<String> tags,
    required Location location,
  }) async {
    final uri = _urlBuilder.getRestaurantsByTags(
      latitude: location.lat.toString(),
      longitude: location.lng.toString(),
    );

    final response = await _dio.httpClient.getUri<Map<String, dynamic>>(
      uri,
      data: {'tags': tags},
    );
    final data = response.json();
    if (!response.isOk) {
      throw YandexEatsApiRequestFailure(
        body: data,
        statusCode: response.statusCode,
      );
    }

    final restaurants = data['restaurants'] as List;
    return restaurants
        .map((e) => Restaurant.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Menu>> getMenu(String placeId) async {
    final uri = _urlBuilder.buildRestaurantsMenuUrl(placeId);

    final response = await _dio.httpClient.getUri<Map<String, dynamic>>(
      uri,
    );
    final data = response.json();
    if (!response.isOk) {
      throw YandexEatsApiRequestFailure(
        body: data,
        statusCode: response.statusCode,
      );
    }

    final menu = data['menus'] as List<dynamic>;
    return menu
        .map((dynamic e) => Menu.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<CreditCard> addCreditCard({
    required String number,
    required String expiryDate,
    required String cvv,
  }) async {
    final uri = _urlBuilder.addCreditCard(number: number);

    final response = await _dio.httpClient.postUri<Map<String, dynamic>>(
      uri,
      data: {
        'expiry_date': expiryDate,
        'cvv': cvv,
      },
    );
    if (!response.isCreated) {
      throw YandexEatsApiRequestFailure(
        body: <String, String>{},
        statusCode: response.statusCode,
      );
    }
    return CreditCard.fromJson(
      response.json()['credit_card'] as Map<String, dynamic>,
    );
  }

  Future<void> deleteCreditCard({
    required String number,
  }) async {
    final uri = _urlBuilder.deleteCreditCard(number: number);

    await _dio.httpClient.deleteUri<String>(
      uri,
    );
  }

  Future<List<CreditCard>> getCreditCards() async {
    final uri = _urlBuilder.getCreditCards();

    final response = await _dio.httpClient.getUri<Map<String, dynamic>>(
      uri,
    );
    final data = response.json();
    if (!response.isOk) {
      throw YandexEatsApiRequestFailure(
        body: data,
        statusCode: response.statusCode,
      );
    }
    final creditCards = data['credit_cards'] as List<dynamic>;

    return creditCards
        .map((e) => CreditCard.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> addOrderMenuItem({
    required String orderId,
    required String name,
    required String quantity,
    required String price,
    required String imageUrl,
  }) async {
    final uri = _urlBuilder.addOrderMenuItem(orderId: orderId);

    final response = await _dio.httpClient.postUri<String>(
      uri,
      data: {
        'name': name,
        'price': price,
        'quantity': quantity,
        'image_url': imageUrl,
      },
    );
    if (!response.isCreated) {
      throw YandexEatsApiRequestFailure(
        body: <String, String>{},
        statusCode: response.statusCode,
      );
    }
  }

  Future<String> createOrder({
    required String createdAt,
    required String restaurantPlaceId,
    required String restaurantName,
    required String orderAddress,
    required String totalOrderSum,
    required String orderDeliveryFee,
  }) async {
    final id = generateOrderId();
    final uri = _urlBuilder.createOrder(id: id);

    final response = await _dio.httpClient.postUri<String>(
      uri,
      data: {
        'address': orderAddress,
        'created_at': createdAt,
        'restaurant_place_id': restaurantPlaceId,
        'restaurant_name': restaurantName,
        'total_order_sum': totalOrderSum,
        'delivery_fee': orderDeliveryFee,
      },
    );
    if (!response.isCreated) {
      throw YandexEatsApiRequestFailure(
        body: <String, String>{},
        statusCode: response.statusCode,
      );
    }
    return id;
  }

  Future<void> deleteOrderMenuItems({
    required String orderId,
  }) async {
    final uri = _urlBuilder.deleteOrderMenuItems(orderId: orderId);
    final response = await _dio.httpClient.deleteUri<String>(
      uri,
    );
    if (!response.isCreated) {
      throw YandexEatsApiRequestFailure(
        body: <String, String>{},
        statusCode: response.statusCode,
      );
    }
  }

  Future<List<Order>> getOrders() async {
    final uri = _urlBuilder.getOrders();
    final response = await _dio.httpClient.getUri<Map<String, dynamic>>(
      uri,
    );
    final data = response.json();
    if (!response.isOk) {
      throw YandexEatsApiRequestFailure(
        body: data,
        statusCode: response.statusCode,
      );
    }
    final ordersDetail = data['orders'] as List;
    return ordersDetail
        .map((e) => Order.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Order?> getOrder({required String id}) async {
    final uri = _urlBuilder.getOrder(id: id);
    final response = await _dio.httpClient.getUri<Map<String, dynamic>>(
      uri,
    );
    final data = response.data;
    if (data == null) return null;

    if (!response.isOk) {
      throw YandexEatsApiRequestFailure(
        body: data,
        statusCode: response.statusCode,
      );
    }
    final orderDetails = data['order'] as Map<String, dynamic>;
    return Order.fromJson(orderDetails);
  }

  Future<void> deleteOrder({required String id}) async {
    final uri = _urlBuilder.deleteOrder(id: id);

    final response = await _dio.httpClient.deleteUri<String>(
      uri,
    );
    if (!response.isCreated) {
      throw YandexEatsApiRequestFailure(
        body: <String, String>{},
        statusCode: response.statusCode,
      );
    }
  }

  Future<void> updateOrder({
    required String id,
    String? status,
    String? date,
    String? restaurantPlaceId,
    String? restaurantName,
    String? orderAddress,
    String? totalOrderSum,
    String? orderDeliveryFee,
  }) async {
    final uri = _urlBuilder.updateOrder(id: id);
    final response = await _dio.httpClient.putUri<String>(
      uri,
      data: {
        if (status != null) 'status': status,
        if (date != null) 'created_at': date,
        if (restaurantPlaceId != null) 'restaurant_place_id': restaurantPlaceId,
        if (restaurantName != null) 'restaurant_name': restaurantName,
        if (orderAddress != null) 'address': orderAddress,
        if (totalOrderSum != null) 'total_order_sum': totalOrderSum,
        if (orderDeliveryFee != null) 'delivery_fee': orderDeliveryFee,
      },
    );
    if (!response.isCreated) {
      throw YandexEatsApiRequestFailure(
        body: <String, String>{},
        statusCode: response.statusCode,
      );
    }
  }
}

extension on Response<Map<String, dynamic>> {
  Map<String, dynamic> json() {
    try {
      return data!;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        YandexEatsApiMalformedResponse(error: error),
        stackTrace,
      );
    }
  }
}

extension on Response<dynamic> {
  bool get isOk => statusCode == HttpStatus.ok;
  bool get isCreated => statusCode == HttpStatus.created;
}
