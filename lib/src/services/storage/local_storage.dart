import 'dart:async';
import 'dart:convert' show jsonDecode;

import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/models/credit_card.dart';
import 'package:papa_burger/src/models/user.dart';
import 'package:papa_burger_server/api.dart' as server;
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

class LocalStorage {
  factory LocalStorage() => _instance;

  LocalStorage._(); 
  
  static final _instance = LocalStorage._();

  late final SharedPreferences _prefs;

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
    _prefs = await SharedPreferences.getInstance();
  }

  void deleteUserCookies() {
    _prefs
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
    _prefs.setString(_uidKey, uid);
  }

  void saveUser(String user) {
    _prefs.setString(_userKey, user);
  }

  Stream<User?> get userFromDB async* {
    final uid = _prefs.getString(_uidKey);
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
    final user = _prefs.getString(_userKey);
    if (user == null) {
      return null;
    } else {
      return User.fromJson(user);
    }
  }

  void deleteDuration() {
    _prefs.remove(_durationKey);
  }

  void saveToken(String token) {
    _prefs.setString(_tokenKey, token);
  }

  String get getToken => _prefs.getString(_tokenKey) ?? '';

  void saveEmail(String email) {
    _prefs.setString(_emailKey, email);
  }

  String get getEmail => _prefs.getString(_emailKey) ?? '';

  void savePassword(String password) {
    _prefs.setString(_passwordKey, password);
  }

  String get getPassword => _prefs.getString(_passwordKey) ?? '';

  void saveUsername(String username) {
    _prefs.setString(_userNameKey, username);
  }

  String get getUsername => _prefs.getString(_userNameKey) ?? '';

  void setFirstInstall() {
    _prefs.setBool('isFirstInstall', true);
  }

  bool get isFirstInstall => _prefs.getBool('isFirstInstall') ?? false;

  void saveTimer(int duration) {
    _prefs.setInt(_durationKey, duration);
  }

  int get getTimer => _prefs.getInt(_durationKey) ?? 60;

  void saveLat(double lat) {
    _latController.sink.add(lat);
    _prefs.setDouble(_latitudeKey, lat);
  }

  void saveLng(double lng) {
    _lngController.sink.add(lng);
    _prefs.setDouble(_longitudeKey, lng);
  }

  void saveLatLng(double lat, double lng) {
    addLatLng(lat, lng);
    _prefs
      ..setDouble(_latitudeKey, lat)
      ..setDouble(_longitudeKey, lng);
  }

  void saveLatTemp(double lat) {
    _prefs.setDouble(_latitudeTempKey, lat);
  }

  void saveLngTemp(double lng) {
    _prefs.setDouble(_longitudeTempKey, lng);
  }

  void saveTemporaryLatLngForUpdate(double lat, double lng) {
    saveLatTemp(lat);
    saveLngTemp(lng);
  }

  void clearTempLatLng() {
    _prefs
      ..remove(_latitudeTempKey)
      ..remove(_longitudeTempKey);
  }

  bool get hasAddress => latitude != 0 && longitude != 0;

  double get latitude => _prefs.getDouble(_latitudeKey) ?? 0;

  double get longitude => _prefs.getDouble(_longitudeKey) ?? 0;

  final StreamController<double> _latController = StreamController.broadcast();

  final StreamController<double> _lngController = StreamController.broadcast();

  final StreamController<(double lat, double lng)> _latLngController =
      StreamController.broadcast();

  void addLatLng(double lat, double lng) =>
      _latLngController.sink.add((lat, lng));

  Stream<double> get latStream => _latController.stream;

  Stream<double> get lngStream => _lngController.stream;

  Stream<(double lat, double lng)> get latLngStream => _latLngController.stream;

  double get tempLatitude => _prefs.getDouble(_latitudeTempKey) ?? 0;

  double get tempLongitude => _prefs.getDouble(_longitudeTempKey) ?? 0;

  void saveAddressName(String address) {
    _prefs.setString(_addressKey, address);
  }

  String get getAddress => _prefs.getString(_addressKey) ?? noLocation;

  void saveCreditCardSelection(CreditCard creditCard) {
    _prefs.setString(
      _cardSelection,
      creditCard.toJson(),
    );
  }

  void deleteCreditCardSelection() {
    _prefs.remove(_cardSelection);
  }

  CreditCard get getSelectedCreditCard {
    final jsonString = _prefs.getString(_cardSelection) ?? '';
    if (jsonString.isEmpty) {
      return const CreditCard.empty();
    }
    final json = jsonDecode(jsonString);
    return CreditCard.fromJson(json as Map<String, dynamic>);
  }
}
