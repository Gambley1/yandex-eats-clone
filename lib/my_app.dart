import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocProvider, MultiBlocProvider, ReadContext;
import 'package:papa_burger/src/restaurant.dart'
    show Api, AppTheme, LoginCubit, Routes, ShowPasswordCubit, UserRepository;
import 'package:papa_burger/src/views/pages/main/components/drawer/views/orders/state/orders_bloc.dart';
import 'package:papa_burger/src/views/pages/main/state/bloc/main_test_bloc.dart';
import 'package:papa_burger/src/views/pages/notification/state/notification_bloc.dart';
import 'package:papa_burger/src/views/pages/register/state/register_cubit.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _userApi = Api();
  late final _userRepository = UserRepository(api: _userApi);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MainTestBloc()..add(const MainTestStarted()),
        ),
        BlocProvider(create: (context) => ShowPasswordCubit()),
        BlocProvider(
          create: (context) => RegisterCubit(
            mainTestBloc: context.read<MainTestBloc>(),
          ),
        ),
        BlocProvider(
          create: (context) =>
              NotificationBloc()..add(const NotificationStarted()),
        ),
        BlocProvider(
          create: (context) => LoginCubit(
            userRepository: _userRepository,
            mainTestBloc: context.read<MainTestBloc>(),
          ),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => OrdersBloc()..add(const OrdersStarted()),
        )
      ],
      child: MaterialApp(
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        debugShowCheckedModeBanner: false,
        title: 'Papa Burger',
        theme: AppTheme.lightTheme,
        routes: Routes.routes,
      ),
    );
  }
}
