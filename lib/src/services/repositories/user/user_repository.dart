import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/restaurant.dart'
    show
        Api,
        BaseUserRepository,
        EmailAlreadyRegisteredApiException,
        EmailAlreadyRegisteredException,
        LocalStorage,
        UserNotFoundApiException,
        UserNotFoundException,
        logger;

@immutable
class UserRepository implements BaseUserRepository {
  const UserRepository({
    required this.api,
  });

  final Api api;

  static final LocalStorage _localStorage = LocalStorage.instance;

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
  void logout() {
    api.logOut();
    _localStorage.deleteUserCookies();
  }
}
