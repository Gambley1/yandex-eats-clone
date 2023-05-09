import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/restaurant.dart'
    show
        Api,
        BaseUserRepository,
        CartBlocTest,
        EmailAlreadyRegisteredApiException,
        EmailAlreadyRegisteredException,
        LocalStorage,
        MainPageService,
        UserNotFoundApiException,
        UserNotFoundException,
        logger;
import 'package:papa_burger/src/views/pages/cart/state/selected_card_notifier.dart';

@immutable
class UserRepository implements BaseUserRepository {
  const UserRepository({
    required this.api,
  });

  final Api api;

  static final LocalStorage _localStorage = LocalStorage.instance;
  static final CartBlocTest _cartBloc = CartBlocTest();
  static final MainPageService _mainPageService = MainPageService();
  static final SelectedCardNotifier _selectedCardNotifier =
      SelectedCardNotifier();

  @override
  Future<void> logIn(String email, String password) async {
    try {
      final firebaseUser = await api.signIn(email, password);
      // _localStorage.saveCookieUserCredentials(firebaseUser!.uid,
      //     firebaseUser.email!, firebaseUser.displayName ?? 'Unknown');
      logger.w(firebaseUser);
      _localStorage.saveUsername(firebaseUser!.displayName!);
      _localStorage.saveToken(firebaseUser.uid);
      _localStorage.saveEmail(firebaseUser.email!);

      _mainPageService.mainBloc.fetchAllRestaurantsByLocation();
      _mainPageService.mainBloc.refresh();
    } on UserNotFoundApiException {
      logger.w('User not found Exception');
      throw UserNotFoundException();
    }
  }

  @override
  void register(String email, String password) async {
    try {
      final firebaseUser = await api.signUp(email, password);
      _localStorage.saveCookieUserCredentials(firebaseUser!.uid,
          firebaseUser.email!, firebaseUser.displayName ?? 'Unknown');
    } on EmailAlreadyRegisteredApiException {
      throw EmailAlreadyRegisteredException();
    }
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
  void logout() async {
    api.logOut();
    _localStorage.deleteUserCookies();
    _selectedCardNotifier.deleteCardSelection();
    _cartBloc.removeAllItems();
    _mainPageService.mainBloc.clearAllRestaurants;
  }
}
