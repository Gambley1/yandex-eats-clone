import 'dart:isolate';

import 'package:papa_burger/src/restaurant.dart';

Future<void> useRestaurantsIsolate() async {
  final mainBloc = MainBloc();
  final localStorage = LocalStorage.instance;
  final recievePort = ReceivePort();
  final lat = localStorage.latitude;
  final lng = localStorage.longitude;
  try {
    final isolate = await Isolate.spawn(
      _getAllRestaurantsIsolate,
      [recievePort.sendPort, lat, lng],
    );
    final response = await recievePort.first as List<GoogleRestaurant>;
    mainBloc.allRestaurants.addAll(response);
    isolate.kill(priority: Isolate.immediate);

    logger.i('Result: $response');
  } catch (e) {
    recievePort.close();
    logger.e(e);
  }
}

Future<void> _getAllRestaurantsIsolate(
  List<dynamic> args,
) async {
  final sendPort = args[0] as SendPort;
  final lat = args[1].toString();
  final lng = args[2].toString();
  try {
    final page = await RestaurantApi()
        .getDBRestaurantsPageFromBackend(
          latitude: lat,
          longitude: lng,
        )
        .timeout(const Duration(seconds: 10));
    sendPort.send(page.restaurants);
  } catch (e) {
    logger.e(e);
  }
}
