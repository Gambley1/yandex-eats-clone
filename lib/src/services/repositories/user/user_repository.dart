import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/restaurant.dart'
    show Api, BaseUserRepository, CartBloc, LocalStorage, MainPageService;
import 'package:papa_burger/src/views/pages/cart/state/selected_card_notifier.dart';

@immutable
class UserRepository implements BaseUserRepository {
  const UserRepository({
    required this.api,
  });

  final Api api;

  static final LocalStorage _localStorage = LocalStorage.instance;
  static final CartBloc _cartBloc = CartBloc();
  static final MainPageService _mainPageService = MainPageService();
  static final SelectedCardNotifier _selectedCardNotifier =
      SelectedCardNotifier();

  @override
  Future<void> logIn(String email, String password) async {
    // try {
    //   final firebaseUser = await api.signIn(email, password);
    //   // _localStorage.saveCookieUserCredentials(firebaseUser!.uid,
    //   //     firebaseUser.email!, firebaseUser.displayName ?? 'Unknown');
    //   logger.w(firebaseUser);
    //   _localStorage
    //     ..saveUsername(firebaseUser!.displayName!)
    //     ..saveToken(firebaseUser.uid)
    //     ..saveEmail(firebaseUser.email!);

    //   await _mainPageService.mainBloc.fetchAllRestaurantsByLocation();
    //   await _mainPageService.mainBloc.refresh();
    // } catch (e) {
    //   logger.e(e);
    // }
    // on UserNotFoundApiException {
    //   logger.w('User not found Exception');
    //   throw UserNotFoundException();
    // }
  }

  @override
  Future<void> register(String email, String password) async {
    // try {
    //   final firebaseUser = await api.signUp(email, password);
    //   _localStorage.saveCookieUserCredentials(
    //     firebaseUser!.uid,
    //     firebaseUser.email!,
    //     firebaseUser.displayName ?? 'Unknown',
    //   );
    // } on EmailAlreadyRegisteredApiException {
    //   // throw EmailAlreadyRegisteredException();
    //   throw Exception('Email already registered.');
    // }
  }

  // @override
  // void googleLogIn() async {
  //   try {
  //     final googleUser = await api.googleSignIn();

  //     _localStorage.saveEmail(googleUser.email!);
  //     _localStorage.saveUsername(googleUser.username!);
  //     _localStorage.saveToken(googleUser.token);
  //   } on InvalidCredentialsApiException {
  //     throw InvalidCredentialsException();
  //   }
  // }

  @override
  Future<void> logout() async {
    // api.logOut();
    _localStorage.deleteUserCookies();
    _selectedCardNotifier.deleteCardSelection();
    await _cartBloc.removeAllItems();
    _mainPageService.mainBloc.clearAllRestaurants;
  }
}
