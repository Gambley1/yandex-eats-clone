// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:storage/storage.dart';
import 'package:yandex_food_api/client.dart';

part 'restaurants_storage.dart';

/// {@template restaurants_exception}
/// Exceptions from restaurants repository.
/// {@endtemplate}
abstract class RestaurantsException implements Exception {
  /// {@macro restaurants_exception}
  const RestaurantsException(this.error);

  /// The error which was caught.
  final Object error;

  @override
  String toString() => 'Restaurants exception error: $error';
}

/// {@template get_restaurants_failure}
/// Thrown when fetching restaurants fails.
/// {@endtemplate}
class GetRestaurantsFailure extends RestaurantsException {
  /// {@macro get_restaurants_failure}
  const GetRestaurantsFailure(super.error);
}

/// {@template get_menu_failure}
/// Thrown when fetching menu fails.
/// {@endtemplate}
class GetMenuFailure extends RestaurantsException {
  /// {@macro get_menu_failure}
  const GetMenuFailure(super.error);
}

/// {@template popular_search_failure}
/// Thrown when fetching popular restaurants fails.
/// {@endtemplate}
class PopularSearchFailure extends RestaurantsException {
  /// {@macro popular_search_failure}
  const PopularSearchFailure(super.error);
}

/// {@template relevant_search_failure}
/// Thrown when fetching relevant restaurants fails.
/// {@endtemplate}
class RelevantSearchFailure extends RestaurantsException {
  /// {@macro relevant_search_failure}
  const RelevantSearchFailure(super.error);
}

/// {@template get_restaurant_failure}
/// Thrown when fetching restaurant fails.
/// {@endtemplate}
class GetRestaurantFailure extends RestaurantsException {
  /// {@macro get_restaurant_failure}
  const GetRestaurantFailure(super.error);
}

/// {@template get_restaurants_tags_failure}
/// Thrown when fetching restaurants tags fails.
/// {@endtemplate}
class GetTagsFailure extends RestaurantsException {
  /// {@macro get_restaurants_tags_failure}
  const GetTagsFailure(super.error);
}

/// {@template get_restaurants_by_tags_failure}
/// Thrown when fetching restaurants by tags fails.
/// {@endtemplate}
class GetRestaurantsByTagsFailure extends RestaurantsException {
  /// {@macro get_restaurants_by_tags_failure}
  const GetRestaurantsByTagsFailure(super.error);
}

/// {@template bookmark_restaurant_failure}
/// Thrown when bookmarking restaurant fails.
/// {@endtemplate}
class BookmarkRestaurantFailure extends RestaurantsException {
  /// {@macro bookmark_restaurant_failure}
  const BookmarkRestaurantFailure(super.error);
}

/// {@template restaurants_repository}
/// A repository that manages restaurants data flow.
/// {@endtemplate}
class RestaurantsRepository {
  /// {@macro restaurants_repository}
  const RestaurantsRepository({
    required YandexEatsApiClient apiClient,
    required RestaurantsStorage storage,
  })  : _apiClient = apiClient,
        _storage = storage;

  final YandexEatsApiClient _apiClient;
  final RestaurantsStorage _storage;

  Future<List<Restaurant>> getRestaurants({
    required Location location,
    int? limit,
    int? offset,
  }) async {
    try {
      return _apiClient.getRestaurants(
        location: location,
        limit: limit,
        offset: offset,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        GetRestaurantsFailure(error),
        stackTrace,
      );
    }
  }

  Future<List<Menu>> getMenu({required String placeId}) async {
    try {
      return await _apiClient.getMenu(placeId);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetMenuFailure(error), stackTrace);
    }
  }

  Future<List<Restaurant>> popularSearch({
    required Location location,
  }) async {
    try {
      return _apiClient.popularSearch(
        location: location,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        PopularSearchFailure(error),
        stackTrace,
      );
    }
  }

  Future<List<Restaurant>> relevantSearch({
    required String term,
    required Location location,
  }) async {
    try {
      return _apiClient.relevantSearch(
        term: term,
        location: location,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        RelevantSearchFailure(error),
        stackTrace,
      );
    }
  }

  Future<Restaurant?> getRestaurant({
    required String id,
    Location? location,
  }) async {
    try {
      return _apiClient.getRestaurant(
        id: id,
        location: location,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetRestaurantFailure(error), stackTrace);
    }
  }

  Future<List<Tag>> getTags({
    required Location location,
  }) async {
    try {
      return _apiClient.getTags(location: location);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetTagsFailure(error), stackTrace);
    }
  }

  Future<List<Restaurant>> getRestaurantsByTags({
    required List<String> tags,
    required Location location,
  }) async {
    try {
      return _apiClient.getRestaurantsByTags(
        tags: tags,
        location: location,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetRestaurantsByTagsFailure(error), stackTrace);
    }
  }

  /// Broadcasts bookmarked restaurants value from User Storage.
  ///
  /// * Initial value comes from persisted local storage.
  Stream<List<String>> bookmarkedRestaurants() =>
      _storage.bookmarkedRestaurants();

  /// Fetches bookmarked restaurants value from local storage.
  List<String> getBookmarkedRestaurants() =>
      _storage.getBookmarkedRestaurants();

  /// Clears bookmarked restaurants value in local storage.
  Future<void> clearBookmarkedRestaurants() =>
      _storage.clearBookmarkedRestaurants();

  /// Changes bookmarked restaurants in local storage and emits new value
  /// to [bookmarkedRestaurants] stream.
  ///
  /// * New bookmarked restaurant is persisted in local storage.
  Future<void> bookmarkRestaurant({required String placeId}) async {
    try {
      await _storage.setRestaurantsBookmarked(placeId: placeId);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(BookmarkRestaurantFailure(error), stackTrace);
    }
  }
}
