import 'package:flutter/material.dart';
import 'package:papa_burger/src/app/routes/app_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter().router;

    return ShadApp.materialRouter(
      title: 'Papa Burger',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ShadThemeData(
        brightness: Brightness.light,
        colorScheme: const ShadBlueColorScheme.light(),
      ),
      darkTheme: ShadThemeData(
        brightness: Brightness.dark,
        colorScheme: const ShadBlueColorScheme.dark(),
      ),
      routerConfig: router,
    );
  }
}
