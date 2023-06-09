import 'dart:async' show TimeoutException, runZonedGuarded;

import 'package:device_preview_screenshot/device_preview_screenshot.dart';
// import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:flutter/material.dart' show WidgetsFlutterBinding, runApp;
import 'package:papa_burger/src/restaurant.dart'
    show CompositionRoot, MyApp, logger;

void main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await CompositionRoot.configureApp();
      // await Firebase.initializeApp(
      //   options: DefaultFirebaseOptions.currentPlatform,
      // );
      runApp(
        DevicePreview(
          // ignore: avoid_redundant_argument_values
          enabled: false,
          tools: const [
            ...DevicePreview.defaultTools,
            DevicePreviewScreenshot()
          ],
          builder: (context) => MyApp(),
        ),
      );
    },
    (error, stack) {
      logger
        ..e(error)
        ..e(stack);
    },
  );
}
