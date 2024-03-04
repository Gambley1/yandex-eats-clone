import 'dart:isolate';

import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/models/models.dart';
import 'package:papa_burger/src/services/network/api/api.dart';
import 'package:papa_burger/src/services/storage/storage.dart';
import 'package:papa_burger/src/views/pages/main/state/main_bloc.dart';

Future<void> useRestaurantsIsolate() async {
  final mainBloc = MainBloc();
  final localStorage = LocalStorage();
  final recievePort = ReceivePort();
  final lat = localStorage.latitude;
  final lng = localStorage.longitude;
  try {
    final isolate = await Isolate.spawn(
      _getAllRestaurantsIsolate,
      [recievePort.sendPort, lat, lng],
    );
    final response = await recievePort.first as List<Restaurant>;
    mainBloc.allRestaurants.addAll(response);
    isolate.kill(priority: Isolate.immediate);
  } catch (e) {
    recievePort.close();
    logE(e);
  }
}

Future<void> _getAllRestaurantsIsolate(
  List<dynamic> args,
) async {
  final sendPort = args[0] as SendPort;
  final lat = args[1].toString();
  final lng = args[2].toString();
  try {
    final page = await RestaurantApi().getRestaurantsPage(
      latitude: lat,
      longitude: lng,
    );
    sendPort.send(page.restaurants);
  } catch (e) {
    logE(e);
  }
}
