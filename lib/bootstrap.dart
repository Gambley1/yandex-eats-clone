import 'dart:async';

import 'package:device_preview_screenshot/device_preview_screenshot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:papa_burger/src/restaurant.dart' show CompositionRoot, logger;
import 'package:papa_burger/src/services/network/notification_service.dart';

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
  FlutterError.onError = (details) => logger
    ..e(details.exceptionAsString())
    ..e(details.stack);
  // Bloc.observer = AppBlocObserver();

  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await CompositionRoot.configureApp();
      runApp(
        DevicePreview(
          enabled: false,
          tools: const [
            ...DevicePreview.defaultTools,
            DevicePreviewScreenshot()
          ],
          builder: (context) => builder(),
        ),
      );
      await NotificationService.initNotifications();
    },
    (error, stackTrace) => logger
      ..e(error)
      ..e(stackTrace),
  );
}
