import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart'
    show
        Api,
        LoginCubit,
        LoginView,
        MainPage,
        ShowPasswordCubit,
        UserRepository;
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, User;
import 'package:flutter_bloc/flutter_bloc.dart'
    show MultiBlocProvider, BlocProvider;
import 'package:flutter_screenutil/flutter_screenutil.dart' show ScreenUtilInit;

class MyApp extends StatelessWidget {
  MyApp({
    Key? key,
  }) : super(key: key);

  late final _userApi = Api();
  late final _userRepository = UserRepository(api: _userApi);

  _homePage() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        return snapshot.data != null ? const MainPage() : const LoginView();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => LoginCubit(userRepository: _userRepository)),
        BlocProvider(create: (context) => ShowPasswordCubit()),
      ],
      child: ScreenUtilInit(
        minTextAdapt: true,
        designSize: const Size(375, 812),
        splitScreenMode: true,
        builder: ((context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Papa Burger',
            themeMode: ThemeMode.light,
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              fontFamily: 'Quicksand',
              brightness: Brightness.light,
              appBarTheme: const AppBarTheme(elevation: 0),
            ),
            home: _homePage(),
          );
        }),
      ),
    );
  }
}
