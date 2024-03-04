import 'dart:async';

import 'package:device_preview_screenshot/device_preview_screenshot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/models/models.dart';
import 'package:papa_burger/src/services/network/notification_service.dart';
import 'package:papa_burger/src/services/repositories/local_storage/local_storage.dart';
import 'package:papa_burger/src/services/storage/storage.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(
    Bloc<dynamic, dynamic> bloc,
    dynamic event,
  ) {
    super.onEvent(bloc, event);
    debugPrint('onEvent(${bloc.runtimeType}, $event)');
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    debugPrint('onTransition(${bloc.runtimeType}, $transition)');
  }

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
      await Future.wait([
        dotenv.load(),
        NotificationService.requestNotificationPermission(),
        LocalStorage().init(),
        Hive.initFlutter().then((_) => Hive.registerAdapter(ItemAdapter())),
        LocalStorageRepository.initBoxes(),
      ]);

      SystemUiOverlayTheme.setPortraitOrientation();

      runApp(
        DevicePreview(
          enabled: false,
          tools: const [
            ...DevicePreview.defaultTools,
            DevicePreviewScreenshot(),
          ],
          builder: (context) => builder(),
        ),
      );
      await NotificationService.initNotifications();
    },
    (error, stackTrace) => logE(error.toString(), stackTrace: stackTrace),
  );
}
