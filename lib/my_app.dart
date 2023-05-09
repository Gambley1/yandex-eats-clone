import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart'
    show Api, AppTheme, LoginCubit, Routes, ShowPasswordCubit, UserRepository;
import 'package:flutter_bloc/flutter_bloc.dart'
    show MultiBlocProvider, BlocProvider;
import 'package:papa_burger/src/views/pages/main_page/state/test_provider.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  MyApp({
    Key? key,
  }) : super(key: key);

  late final _userApi = Api();
  late final _userRepository = UserRepository(api: _userApi);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => LoginCubit(userRepository: _userRepository)),
        BlocProvider(create: (context) => ShowPasswordCubit()),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => TestProvider(),
            lazy: false,
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Papa Burger',
          themeMode: ThemeMode.system,
          theme: AppTheme.lightTheme,
          routes: Routes.routes,
        ),
      ),
    );
  }
}
