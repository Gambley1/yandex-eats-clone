import 'package:papa_burger/src/home/bloc/location_bloc.dart';
import 'package:papa_burger/src/map/helper/location_helper.dart';
import 'package:papa_burger/src/services/network/api/api.dart';

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
