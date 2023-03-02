import 'dart:async';

import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CompositionRoot.configureApp();
  // Bloc.observer = const SimpleBlocObserver();
  runZonedGuarded(
      () => runApp(
            MyApp(),
          ),
      (error, stack) {});
}
