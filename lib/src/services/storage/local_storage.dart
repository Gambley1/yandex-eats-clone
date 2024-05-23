import 'dart:async';
import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger_server/api.dart' as server;
import 'package:shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

class LocalStorage {
  factory LocalStorage() => _instance;

  LocalStorage._();

  static final _instance = LocalStorage._();

  late final SharedPreferences _sharedPreferences;

  static const String _tokenKey = 'token';
  static const String _uidKey = 'uid';
  static const String _userKey = 'user';
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
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  void deleteUserCookies() {
    _sharedPreferences
      ..remove(_tokenKey)
      ..remove(_uidKey)
      ..remove(_userKey)
      ..remove(_emailKey)
      ..remove(_passwordKey)
      ..remove(_userNameKey)
      ..remove(_locationKey)
      ..remove(_addressKey)
      ..remove(_latitudeKey)
      ..remove(_latitudeTempKey)
      ..remove(_longitudeKey)
      ..remove(_longitudeTempKey)
      ..remove(_durationKey)
      ..remove(_cardSelection)
      ..remove(_cardSelection);
  }

  void saveCookieUserCredentials(String token, String email, String username) {
    saveToken(token);
    saveEmail(email);
    saveUsername(username);
  }

  void saveUid(String uid) {
    _sharedPreferences.setString(_uidKey, uid);
  }

  void saveUser(String user) {
    _sharedPreferences.setString(_userKey, user);
  }

  Stream<User?> get userFromDB async* {
    final uid = _sharedPreferences.getString(_uidKey);
    try {
      final apiClient = server.ApiClient();
      if (uid != null) {
        final user = await apiClient.getUser(uid);
        saveUser(user.toJson());

        yield User(
          uid: user.uid,
          email: user.email,
          username: user.name,
          profilePicture: user.profilePicture,
          isPremiumActive: user.isPremiumActive,
        );
      }
    } catch (e) {
      logE(e);
      yield null;
    }
  }

  User? get getUser {
    final userJsonString = _sharedPreferences.getString(_userKey);
    if (userJsonString == null) return null;
    return User.fromJson(jsonDecode(userJsonString) as Map<String, dynamic>);
  }

  void deleteDuration() {
    _sharedPreferences.remove(_durationKey);
  }

  void saveToken(String token) {
    _sharedPreferences.setString(_tokenKey, token);
  }

  String get getToken => _sharedPreferences.getString(_tokenKey) ?? '';

  void saveEmail(String email) {
    _sharedPreferences.setString(_emailKey, email);
  }

  String get getEmail => _sharedPreferences.getString(_emailKey) ?? '';

  void savePassword(String password) {
    _sharedPreferences.setString(_passwordKey, password);
  }

  String get getPassword => _sharedPreferences.getString(_passwordKey) ?? '';

  void saveUsername(String username) {
    _sharedPreferences.setString(_userNameKey, username);
  }

  String get getUsername => _sharedPreferences.getString(_userNameKey) ?? '';

  void setFirstInstall() {
    _sharedPreferences.setBool('isFirstInstall', true);
  }

  bool get isFirstInstall =>
      _sharedPreferences.getBool('isFirstInstall') ?? false;

  void saveTimer(int duration) {
    _sharedPreferences.setInt(_durationKey, duration);
  }

  int get getTimer => _sharedPreferences.getInt(_durationKey) ?? 60;

  void saveLat(double lat) {
    _latController.sink.add(lat);
    _sharedPreferences.setDouble(_latitudeKey, lat);
  }

  void saveLng(double lng) {
    _lngController.sink.add(lng);
    _sharedPreferences.setDouble(_longitudeKey, lng);
  }

  void saveLatLng(double lat, double lng) {
    addLatLng(lat, lng);
    _sharedPreferences
      ..setDouble(_latitudeKey, lat)
      ..setDouble(_longitudeKey, lng);
  }

  void saveLatTemp(double lat) {
    _sharedPreferences.setDouble(_latitudeTempKey, lat);
  }

  void saveLngTemp(double lng) {
    _sharedPreferences.setDouble(_longitudeTempKey, lng);
  }

  void saveTemporaryLatLngForUpdate(double lat, double lng) {
    saveLatTemp(lat);
    saveLngTemp(lng);
  }

  void clearTempLatLng() {
    _sharedPreferences
      ..remove(_latitudeTempKey)
      ..remove(_longitudeTempKey);
  }

  bool get hasAddress => latitude != 0 && longitude != 0;

  double get latitude => _sharedPreferences.getDouble(_latitudeKey) ?? 0;

  double get longitude => _sharedPreferences.getDouble(_longitudeKey) ?? 0;

  final StreamController<double> _latController = StreamController.broadcast();

  final StreamController<double> _lngController = StreamController.broadcast();

  final StreamController<(double lat, double lng)> _latLngController =
      StreamController.broadcast();

  void addLatLng(double lat, double lng) =>
      _latLngController.sink.add((lat, lng));

  Stream<double> get latStream => _latController.stream;

  Stream<double> get lngStream => _lngController.stream;

  Stream<(double lat, double lng)> get latLngStream => _latLngController.stream;

  double get tempLatitude =>
      _sharedPreferences.getDouble(_latitudeTempKey) ?? 0;

  double get tempLongitude =>
      _sharedPreferences.getDouble(_longitudeTempKey) ?? 0;

  void saveAddressName(String address) {
    _sharedPreferences.setString(_addressKey, address);
  }

  String get getAddress =>
      _sharedPreferences.getString(_addressKey) ?? noLocation;

  void saveCreditCardSelection(CreditCard creditCard) {
    _sharedPreferences.setString(
      _cardSelection,
      jsonEncode(creditCard.toJson()),
    );
  }

  void deleteCreditCardSelection() {
    _sharedPreferences.remove(_cardSelection);
  }

  CreditCard get getSelectedCreditCard {
    final jsonString = _sharedPreferences.getString(_cardSelection) ?? '';
    if (jsonString.isEmpty) {
      return const CreditCard.empty();
    }
    final json = jsonDecode(jsonString);
    return CreditCard.fromJson(json as Map<String, dynamic>);
  }
}
