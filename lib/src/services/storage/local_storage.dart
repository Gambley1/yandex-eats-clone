import 'dart:convert' show jsonDecode;

import 'package:papa_burger/src/models/payment/credit_card.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;
import 'package:papa_burger/src/restaurant.dart' show noLocation;

class LocalStorage {
  late final SharedPreferences _localStorage;

  static LocalStorage instance = LocalStorage();

  static const String _tokenKey = 'token';
  static const String _emailKey = 'email';
  static const String _passwordKey = 'password';
  static const String _userNameKey = 'user_name';
  static const String _locationKey = 'location';
  static const String _addressKey = 'address';
  static const String _latitudeKey = 'latitude';
  static const String _latitudeTempKey = 'latitude_temp';
  static const String _longitudeKey = 'longitude';
  static const String _longitudeTempKey = 'longitude_temp';
  static const String _durationKey = 'duration';
  static const String _cardSelection = 'card_selection';

  Future<void> init() async {
    _localStorage = await SharedPreferences.getInstance();
  }

  void deleteUserCookies() {
    _localStorage.remove(_addressKey);
    _localStorage.remove(_cardSelection);
    _localStorage.remove(_emailKey);
    _localStorage.remove(_latitudeKey);
    _localStorage.remove(_latitudeTempKey);
    _localStorage.remove(_locationKey);
    _localStorage.remove(_longitudeKey);
    _localStorage.remove(_longitudeTempKey);
    _localStorage.remove(_tokenKey);
    _localStorage.remove(_userNameKey);
  }

  void saveCookieUserCredentials(String token, String email, String username) {
    saveToken(token);
    saveEmail(email);
    saveUsername(username);
  }

  void deleteDuration() {
    _localStorage.remove(_durationKey);
  }

  void saveToken(String token) {
    _localStorage.setString(_tokenKey, token);
  }

  String get getToken => _localStorage.getString(_tokenKey) ?? '';

  void saveEmail(String email) {
    _localStorage.setString(_emailKey, email);
  }

  String get getEmail => _localStorage.getString(_emailKey) ?? '';

  void savePassword(String password) {
    _localStorage.setString(_passwordKey, password);
  }

  String get getPassword => _localStorage.getString(_passwordKey) ?? '';

  void saveUsername(String username) {
    _localStorage.setString(_userNameKey, username);
  }

  String get getUsername => _localStorage.getString(_userNameKey) ?? '';

  void setFirstInstall() {
    _localStorage.setBool('isFirstInstall', true);
  }

  bool get isFirstInstall => _localStorage.getBool('isFirstInstall') ?? false;

  void saveTimer(int duration) {
    _localStorage.setInt(_durationKey, duration);
  }

  int get getTimer => _localStorage.getInt(_durationKey) ?? 60;

  void saveLat(double lat) {
    _localStorage.setDouble(_latitudeKey, lat);
  }

  void saveLng(double lng) {
    _localStorage.setDouble(_longitudeKey, lng);
  }

  void saveLatLng(double lat, double lng) {
    saveLat(lat);
    saveLng(lng);
  }

  void saveLatTemp(double lat) {
    _localStorage.setDouble(_latitudeTempKey, lat);
  }

  void saveLngTemp(double lng) {
    _localStorage.setDouble(_longitudeTempKey, lng);
  }

  void saveTemporaryLatLngForUpdate(double lat, double lng) {
    saveLatTemp(lat);
    saveLngTemp(lng);
  }

  void clearTempLatLng() {
    _localStorage.remove(_latitudeTempKey);
    _localStorage.remove(_longitudeTempKey);
  }

  double get latitude => _localStorage.getDouble(_latitudeKey) ?? 0;

  double get longitude => _localStorage.getDouble(_longitudeKey) ?? 0;

  double get tempLatitude => _localStorage.getDouble(_latitudeTempKey) ?? 0;

  double get tempLongitude => _localStorage.getDouble(_longitudeTempKey) ?? 0;

  void saveAddressName(String address) {
    _localStorage.setString(_addressKey, address);
  }

  String get getAddress => _localStorage.getString(_addressKey) ?? noLocation;

  void saveCreditCardSelection(CreditCard creditCard) {
    _localStorage.setString(
      _cardSelection,
      creditCard.toJson(),
    );
  }

  void deleteCreditCardSelection() {
    _localStorage.remove(_cardSelection);
  }

  CreditCard get getSelectedCreditCard {
    final jsonString = _localStorage.getString(_cardSelection) ?? '';
    if (jsonString.isEmpty) {
      return const CreditCard.empty();
    }
    final json = jsonDecode(jsonString);
    return CreditCard.fromJson(json);
  }
}
