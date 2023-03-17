import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;
import 'package:papa_burger/src/restaurant.dart' show noLocation;

class LocalStorage {
  late final SharedPreferences _localStorage;

  static LocalStorage instance = LocalStorage();

  static const String tokenKey = 'token';
  static const String emailKey = 'email';
  static const String passwordKey = 'password';
  static const String userNameKey = 'user_name';
  static const String locationKey = 'location';
  static const String addressKey = 'address';
  static const String latitudeKey = 'latitude';
  static const String longitudeKey = 'longitude';
  static const String durationKey = 'duration';

  Future<void> init() async {
    _localStorage = await SharedPreferences.getInstance();
  }

  void deleteUserCookies() {
    _localStorage.remove(tokenKey);
    _localStorage.remove(emailKey);
    _localStorage.remove(userNameKey);
    _localStorage.remove(locationKey);
    _localStorage.remove(addressKey);
  }

  void cookieUserCredentials(String token, String email, String username) {
    saveToken(token);
    saveEmail(email);
    saveUsername(username);
  }

  void deleteDuration() {
    _localStorage.remove(durationKey);
  }

  void saveToken(String token) {
    _localStorage.setString(tokenKey, token);
  }

  String get getToken => _localStorage.getString(tokenKey) ?? '';

  void saveEmail(String email) {
    _localStorage.setString(emailKey, email);
  }

  String get getEmail => _localStorage.getString(emailKey) ?? '';

  void savePassword(String password) {
    _localStorage.setString(passwordKey, password);
  }

  String get getPassword => _localStorage.getString(passwordKey) ?? '';

  void saveUsername(String username) {
    _localStorage.setString(userNameKey, username);
  }

  String get getUsername => _localStorage.getString(userNameKey) ?? '';

  void setFirstInstall() {
    _localStorage.setBool('isFirstInstall', true);
  }

  bool get isFirstInstall => _localStorage.getBool('isFirstInstall') ?? false;

  void saveTimer(int duration) {
    _localStorage.setInt(durationKey, duration);
  }

  int get getTimer => _localStorage.getInt(durationKey) ?? 60;

  void saveLat(double lat) {
    _localStorage.setDouble(latitudeKey, lat);
  }

  void saveLng(double lng) {
    _localStorage.setDouble(longitudeKey, lng);
  }

  void saveLatLng(double lat, double lng) {
    saveLat(lat);
    saveLng(lng);
  }

  void saveLocation(LatLng location) {
    _localStorage.setString(
      locationKey,
      'Latitude: ${location.latitude.toStringAsFixed(4)}, Longitude: ${location.longitude.toStringAsFixed(4)}',
    );
  }

  double get latitude => _localStorage.getDouble(latitudeKey) ?? 0;

  double get longitude => _localStorage.getDouble(longitudeKey) ?? 0;

  String get getLocation => _localStorage.getString(locationKey) ?? noLocation;

  void saveAddressName(String address) {
    _localStorage.setString(addressKey, address);
  }

  String get getAddress => _localStorage.getString(addressKey) ?? noLocation;
}
