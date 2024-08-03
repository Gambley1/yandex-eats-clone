import 'dart:async';
import 'dart:developer' as dev;

import 'package:app_ui/app_ui.dart';
import 'package:env/env.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef AppBuilder = FutureOr<Widget> Function(SharedPreferences);

class AppBlocObserver extends BlocObserver {
  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    dev.log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(AppBuilder builder) async {
  FlutterError.onError = (details) {
    logE(details.exceptionAsString(), stackTrace: details.stack);
  };

  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      SystemUiOverlayTheme.setPortraitOrientation();

      await Firebase.initializeApp();

      Bloc.observer = AppBlocObserver();

      Stripe.publishableKey = Env.stripePublishKey;
      await Stripe.instance.applySettings();

      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: kIsWeb
            ? HydratedStorage.webStorageDirectory
            : await getTemporaryDirectory(),
      );

      final sharedPreferences = await SharedPreferences.getInstance();

      runApp(await builder(sharedPreferences));
    },
    (_, __) {},
  );
}
