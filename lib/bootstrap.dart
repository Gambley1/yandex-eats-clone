import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:papa_burger/src/services/network/notification_service.dart';
import 'package:papa_burger/src/services/repositories/local_storage/local_storage.dart';
import 'package:papa_burger/src/services/storage/storage.dart';
import 'package:shared/shared.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    debugPrint('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(Widget Function() builder) async {
  FlutterError.onError = (details) {
    logE(details.exceptionAsString(), stackTrace: details.stack);
  };

  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Hive.initFlutter().then((_) => Hive.registerAdapter(ItemAdapter()));
      await Future.wait([
        NotificationService.requestNotificationPermission(),
        LocalStorage().init(),
        LocalStorageRepository.initBoxes(),
      ]);

      SystemUiOverlayTheme.setPortraitOrientation();

      runApp(builder());
      await NotificationService.initNotifications();
    },
    (error, stackTrace) => logE(error.toString(), stackTrace: stackTrace),
  );
}
