part of 'user_repository.dart';

/// Storage keys for the [UserStorage].
abstract class UserStorageKeys {
  /// The current user location that user picked in the application.
  static const userLocation = '__user_location_key__';
}

/// {@template user_storage}
/// Storage for the [UserRepository].
/// {@endtemplate}
class UserStorage {
  /// {@macro user_storage}
  UserStorage({
    required Storage storage,
  }) : _storage = storage {
    _init();
  }

  final Storage _storage;

  final _userLocationStreamController =
      BehaviorSubject<Location>.seeded(const Location.undefined());

  FutureOr<String?> _getValue() =>
      _storage.read(key: UserStorageKeys.userLocation);
  Future<void> _setValue(String value) => _storage.write(
        key: UserStorageKeys.userLocation,
        value: value,
      );
  Future<void> _clear() => _storage.clear();

  Future<void> _init() async {
    final locationJson = await _getValue();
    if (locationJson != null) {
      final location =
          Location.fromJson(json.decode(locationJson) as Map<String, dynamic>);
      _userLocationStreamController.add(location);
    } else {
      _userLocationStreamController.add(const Location.undefined());
    }
  }

  /// Sets the current user location.
  Future<void> setUserLocation({required Location location}) async {
    _userLocationStreamController.add(location);
    await _setValue(json.encode(location.toJson()));
  }

  /// Broadcasts user location value from stream controller.
  Stream<Location> userLocation() => _userLocationStreamController.stream;

  /// Fetches user location value from stream controller.
  Location getUserLocation() => _userLocationStreamController.value;

  /// Clears user location value in User Storage.
  Future<void> clearUserLocation() async {
    await _clear();
    _userLocationStreamController.add(const Location.undefined());
  }
}
