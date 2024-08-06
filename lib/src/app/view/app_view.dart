import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:yandex_food_delivery_clone/src/app/app.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter().router(context.read<AppBloc>());

    return ShadApp.materialRouter(
      title: 'Yandex Eats',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: const AppTheme().theme,
      darkTheme: const AppDarkTheme().theme,
      materialThemeBuilder: (context, theme) {
        return theme.copyWith(
          appBarTheme: const AppBarTheme(
            surfaceTintColor: AppColors.transparent,
          ),
          textTheme: theme.brightness == Brightness.light
              ? const AppTheme().textTheme
              : const AppDarkTheme().textTheme,
          snackBarTheme: const SnackBarThemeData(
            behavior: SnackBarBehavior.floating,
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            type: BottomNavigationBarType.fixed,
          ),
        );
      },
      routerConfig: router,
    );
  }
}
