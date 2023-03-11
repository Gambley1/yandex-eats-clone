import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart'
    show
        LocalStorage,
        Api,
        UserRepository,
        LoginCubit,
        ShowPasswordCubit,
        TestMainPage,
        LoginView;
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, User;
import 'package:flutter_bloc/flutter_bloc.dart'
    show MultiBlocProvider, BlocProvider;
import 'package:flutter_screenutil/flutter_screenutil.dart' show ScreenUtilInit;

class MyApp extends StatelessWidget {
  MyApp({
    Key? key,
  }) : super(key: key);

  late final LocalStorage _localStorage = LocalStorage.instance;

  // _userApi = Api(userTokenSupplier: () => _localStorage.getFromToken());
  late final _userApi = Api();
  late final _userRepository = UserRepository(api: _userApi);

  late final String token = _localStorage.getToken;
  // late final bool isAuthenticated = token.isNotEmpty ? true : false;

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
            home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                return snapshot.data != null
                    ? const TestMainPage()
                    : const LoginView();
              },
            ),
          );
        }),
      ),
    );
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
