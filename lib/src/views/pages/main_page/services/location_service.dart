import 'package:papa_burger/src/restaurant.dart';

class LocationService {
  late final LocationBloc locationBloc;

  final LocationApi locationApi = LocationApi();
  final LocalStorage _localStorage = LocalStorage.instance;

  LocationService() {
    locationBloc = LocationBloc(
      locationApi: locationApi,
      localStorage: _localStorage,
    );
  }
}
