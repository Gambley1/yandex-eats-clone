import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocProvider, MultiBlocProvider;
import 'package:papa_burger/src/app/app.dart';
import 'package:papa_burger/src/home/bloc/main_test_bloc.dart';
import 'package:papa_burger/src/login/cubit/login_cubit.dart';
import 'package:papa_burger/src/notification/notification.dart';
import 'package:papa_burger/src/orders/bloc/orders_bloc.dart';
import 'package:papa_burger/src/services/repositories/user/user.dart';
import 'package:papa_burger/src/sign_up/cubit/sign_up_cubit.dart';

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
        BlocProvider(
          create: (context) => SignUpCubit(userRepository: userRepository),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => NotificationBloc(),
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
