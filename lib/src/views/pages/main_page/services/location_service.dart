import 'package:papa_burger/src/restaurant.dart'
    show
        ConnectivityService,
        LocalStorage,
        LocationApi,
        LocationBloc,
        LocationHelper,
        LocationNotifier;

class LocationService {
  late final LocationBloc locationBloc;
  late final LocationHelper locationHelper;

  final LocationApi locationApi = LocationApi();
  final LocalStorage _localStorage = LocalStorage.instance;
  final LocationNotifier locationNotifier = LocationNotifier();
  final ConnectivityService _connectivityService = ConnectivityService();

  LocationService() {
    locationBloc = LocationBloc(
      locationApi: locationApi,
      localStorage: _localStorage,
      connectivityService: _connectivityService,
    );

    locationHelper = LocationHelper(
      localStorage: _localStorage,
      locationApi: locationApi,
      locationBloc: locationBloc,
      locationNotifier: locationNotifier,
    );
  }
}
