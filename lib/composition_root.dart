import 'package:hive_flutter/hive_flutter.dart';
import 'package:papa_burger/src/restaurant.dart';

class CompositionRoot {
  static configureApp() async {
    await LocalStorage.instance.init();
    await Hive.initFlutter();
    Hive.registerAdapter(ItemAdapter());
    MyThemeData.setGlobalThemeSettings();
  }
}
