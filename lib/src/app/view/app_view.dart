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
      themeMode: ThemeMode.dark,
      theme: ShadThemeData(
        brightness: Brightness.light,
        colorScheme:
            const ShadBlueColorScheme.light(primary: AppColors.deepBlue),
        textTheme: const AppTheme().shadTextTheme,
        inputTheme: ShadInputTheme(
          placeholderStyle: context.bodyMedium?.copyWith(color: AppColors.grey),
        ),
      ),
      darkTheme: ShadThemeData(
        brightness: Brightness.dark,
        colorScheme: const ShadBlueColorScheme.dark(),
        textTheme: const AppDarkTheme().shadTextTheme,
        inputTheme: ShadInputTheme(
          placeholderStyle: context.bodyMedium?.copyWith(color: AppColors.grey),
        ),
      ),
      materialThemeBuilder: (context, theme) {
        return theme.copyWith(
          appBarTheme: const AppBarTheme(
            surfaceTintColor: AppColors.transparent,
          ),
          textTheme: theme.brightness == Brightness.light
              ? const AppTheme().textTheme
              : const AppDarkTheme().textTheme,
        );
      },
      routerConfig: router,
    );
  }
}
