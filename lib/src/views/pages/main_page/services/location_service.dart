import 'package:papa_burger/src/restaurant.dart';

class LocationService {
  late final LocationBloc locationBloc;

  final LocationApi locationApi = LocationApi();

  LocationService() {
    locationBloc = LocationBloc(locationApi: locationApi);
  }
}
