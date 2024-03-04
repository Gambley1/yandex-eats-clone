import 'package:papa_burger/src/services/network/api/api.dart';
import 'package:papa_burger/src/views/pages/main/components/location/helper/location_helper.dart';
import 'package:papa_burger/src/views/pages/main/state/location_bloc.dart';

class LocationService {
  LocationService() {
    locationBloc = LocationBloc(locationApi: locationApi);

    locationHelper = LocationHelper(
      locationApi: locationApi,
      locationBloc: locationBloc,
      locationNotifier: locationNotifier,
    );
  }
  late final LocationBloc locationBloc;
  late final LocationHelper locationHelper;

  final LocationApi locationApi = LocationApi();
  final LocationNotifier locationNotifier = LocationNotifier();
}
