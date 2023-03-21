import 'package:papa_burger/src/restaurant.dart'
    show ConnectivityService, LocalStorage, LocationApi, LocationBloc;

class LocationService {
  late final LocationBloc locationBloc;

  final LocationApi locationApi = LocationApi();
  final LocalStorage _localStorage = LocalStorage.instance;
  final ConnectivityService _connectivityService = ConnectivityService();

  LocationService() {
    locationBloc = LocationBloc(
      locationApi: locationApi,
      localStorage: _localStorage,
      connectivityService: _connectivityService,
    );
  }
}
