import 'dart:async';

import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:flutter/material.dart' show WidgetsFlutterBinding, runApp;
import 'package:papa_burger/src/restaurant.dart'
    show CompositionRoot, DefaultFirebaseOptions, MyApp, logger;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CompositionRoot.configureApp();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runZonedGuarded(
      () => runApp(
            MyApp(),
          ), (error, stack) {
    logger.e(error.toString());
    logger.e(stack.toString());
  });
}
