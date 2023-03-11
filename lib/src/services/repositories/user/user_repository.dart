import 'package:flutter/foundation.dart' show immutable;
import 'package:firebase_core/firebase_core.dart' show FirebaseException;
import 'package:papa_burger/src/restaurant.dart'
    show
        BaseUserRepository,
        LocalStorage,
        Api,
        logger,
        EmailAlreadyRegisteredApiException,
        EmailAlreadyRegisteredException;

@immutable
class UserRepository implements BaseUserRepository {
  const UserRepository({
    required this.api,
  });

  final Api api;

  static final LocalStorage _localStorage = LocalStorage.instance;

  @override
  void logIn(String email, String password) async {
    try {
      final firebaseUser = await api.signIn(email, password);
      _localStorage.cookieUserCredentials(firebaseUser!.uid,
          firebaseUser.email!, firebaseUser.displayName ?? 'Unknown');
    } on FirebaseException catch (e) {
      logger.e('${e.stackTrace}');
      rethrow;
    }
  }

  @override
  void register(String email, String password) async {
    try {
      final firebaseUser = await api.signUp(email, password);
      _localStorage.cookieUserCredentials(firebaseUser!.uid,
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
