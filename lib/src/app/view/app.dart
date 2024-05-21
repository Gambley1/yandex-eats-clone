import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocProvider, MultiBlocProvider;
import 'package:papa_burger/src/app/app.dart';
import 'package:papa_burger/src/services/repositories/user/user.dart';
import 'package:papa_burger/src/views/pages/login/components/show_password_controller/show_password_cubit.dart';
import 'package:papa_burger/src/views/pages/login/state/login_cubit.dart';
import 'package:papa_burger/src/views/pages/main/components/drawer/views/orders/state/orders_bloc.dart';
import 'package:papa_burger/src/views/pages/main/state/bloc/main_test_bloc.dart';
import 'package:papa_burger/src/views/pages/notification/state/notification_bloc.dart';
import 'package:papa_burger/src/views/pages/register/state/register_cubit.dart';

class App extends StatelessWidget {
  const App({required this.userRepository, super.key});

  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MainTestBloc()..add(const MainTestStarted()),
        ),
        BlocProvider(create: (context) => ShowPasswordCubit()),
        BlocProvider(
          create: (context) => RegisterCubit(userRepository: userRepository),
        ),
        BlocProvider(
          create: (context) =>
              NotificationBloc()..add(const NotificationStarted()),
        ),
        BlocProvider(
          create: (context) => LoginCubit(userRepository: userRepository),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => OrdersBloc()..add(const OrdersStarted()),
        ),
      ],
      child: const AppView(),
    );
  }
}
