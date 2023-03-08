import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:papa_burger/firebase_options.dart';
import 'package:papa_burger/src/restaurant.dart';

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
