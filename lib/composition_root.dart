import 'package:hive_flutter/hive_flutter.dart';
import 'package:papa_burger/src/restaurant.dart'
    show ItemAdapter, LocalStorage, LocalStorageRepository, MyThemeData;

class CompositionRoot {
  static Future<void> configureApp() async {
    await LocalStorage.instance.init();
    await Hive.initFlutter().then(
      (_) => Hive.registerAdapter(
        ItemAdapter(),
      ),
    );
    await LocalStorageRepository.initBoxes();
    MyThemeData.setGlobalThemeSettings();
  }
}
