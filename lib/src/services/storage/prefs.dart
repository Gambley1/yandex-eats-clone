import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:papa_burger/src/restaurant.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  late final SharedPreferences _prefs;

  static Prefs instance = Prefs();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> deleteData() async {
    await _prefs.remove('token');
    await _prefs.remove('email');
    await _prefs.remove('user_name');
  }

  Future<void> upsertUserInfo(
      String token, String email, String username) async {
    await saveToken(token);
    await saveEmail(email);
    await saveUsername(username);
  }

  Future<void> deleteDuration() async {
    await _prefs.remove('duration');
  }

  Future<bool> saveToken(String token) async {
    return await _prefs.setString('token', token);
  }

  String get getToken => _prefs.getString('token') ?? '';

  Future<String?> getFromToken() async {
    return getToken;
  }

  Future<void> saveEmail(String email) async {
    await _prefs.setString('email', email);
  }

  String get getEmail => _prefs.getString('email') ?? '';

  Future<void> savePassword(String password) async {
    await _prefs.setString('password', password);
  }

  String get getPassword => _prefs.getString('password') ?? '';

  Future<void> saveUsername(String username) async {
    await _prefs.setString('user_name', username);
  }

  String get getUsername => _prefs.getString('user_name') ?? '';

  Future<void> setFirstInstall() async {
    await _prefs.setBool('isFirstInstall', true);
  }

  Future<void> saveTimer(int duration) async {
    await _prefs.setInt('duration', duration);
  }

  Future<void> saveLocation(LatLng location) async {
    await _prefs.setStringList(
      'location',
      [
        'Latitude: ${location.latitude.toStringAsFixed(4)}, '
            'Longitude: ${location.longitude.toStringAsFixed(4)}'
      ],
    );
  }

  List<String> get getLocation =>
      _prefs.getStringList('location') ?? ['No location, please pick one.'];

  final streamSubject =
      BehaviorSubject<String>.seeded('No locatio, please pick one.');

  Stream<String> getLocationDynamicly() {
    final List<String> location =
        _prefs.getStringList('location') ?? ['No location, please pick one.'];
    logger.i('location is $location');
    return streamSubject.distinct().switchMap((locValue) {
      final loc = location.first;
      locValue = loc;
      streamSubject.sink.add(loc);
      return streamSubject;
    });
  }

  int get getTimer => _prefs.getInt('duration') ?? 60;

  bool get isFirstInstall => _prefs.getBool('isFirstInstall') ?? false;
}
