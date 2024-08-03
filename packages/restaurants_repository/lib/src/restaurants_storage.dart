part of 'restaurants_repository.dart';

/// Storage keys for the [RestaurantsStorage].
abstract class RestaurantsStorageKeys {
  /// The current bookmarked restaurants that user marked in the application.
  static const bookmarkedRestaurants = '__bookmarked_restaurants_key__';
}

/// {@template user_storage}
/// Storage for the [RestaurantsRepository].
/// {@endtemplate}
class RestaurantsStorage {
  /// {@macro user_storage}
  RestaurantsStorage({
    required ListStorage storage,
  }) : _storage = storage {
    _init();
  }

  final ListStorage _storage;

  final _bookmarkedRestaurantsStreamController =
      BehaviorSubject<List<String>>.seeded([]);

  FutureOr<List<String>?> _getValue() =>
      _storage.read(key: RestaurantsStorageKeys.bookmarkedRestaurants);
  Future<void> _setValue(List<String> value) => _storage.write(
        key: RestaurantsStorageKeys.bookmarkedRestaurants,
        value: value,
      );
  Future<void> _clear() => _storage.clear();

  Future<void> _init() async {
    final bookmarkedRestaurants = await _getValue();
    if (bookmarkedRestaurants != null) {
      _bookmarkedRestaurantsStreamController.add(bookmarkedRestaurants);
    }
  }

  /// Sets the current user location.
  Future<void> setRestaurantsBookmarked({required String placeId}) async {
    final bookmarkedRestaurants = _bookmarkedRestaurantsStreamController.value;
    bookmarkedRestaurants.contains(placeId)
        ? bookmarkedRestaurants.remove(placeId)
        : bookmarkedRestaurants.add(placeId);
    await _setValue(bookmarkedRestaurants);
    _bookmarkedRestaurantsStreamController.add(bookmarkedRestaurants);
  }

  /// Broadcasts bookmarked restaurants value from stream controller.
  Stream<List<String>> bookmarkedRestaurants() =>
      _bookmarkedRestaurantsStreamController.stream;

  /// Fetches bookmarked restaurants value from stream controller.
  List<String> getBookmarkedRestaurants() =>
      _bookmarkedRestaurantsStreamController.value;

  /// Clears bookmarked restaurants value in User Storage.
  Future<void> clearBookmarkedRestaurants() async {
    await _clear();
    _bookmarkedRestaurantsStreamController.add([]);
  }
}
