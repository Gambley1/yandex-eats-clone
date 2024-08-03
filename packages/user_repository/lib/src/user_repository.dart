import 'dart:async';
import 'dart:convert';

import 'package:authentication_client/authentication_client.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:storage/storage.dart';
import 'package:user_repository/src/models/models.dart';
import 'package:user_repository/src/models/user.dart';
import 'package:user_repository/user_repository.dart';
import 'package:yandex_food_api/client.dart';

part 'user_storage.dart';

/// {@template user_failure}
/// A base failure for the user repository failures.
/// {@endtemplate}
abstract class UserFailure with EquatableMixin implements Exception {
  /// {@macro user_failure}
  const UserFailure(this.error);

  /// The error which was caught.
  final Object error;

  @override
  List<Object> get props => [error];
}

/// {@template change_user_location_failure}
/// Thrown when changing user location fails.
/// {@endtemplate}
class ChangeUserLocationFailure extends UserFailure {
  /// {@macro change_user_location_failure}
  const ChangeUserLocationFailure(super.error);
}

/// {@template user_repository}
/// A repository that manages user data flow.
/// {@endtemplate}
class UserRepository {
  /// {@macro user_repository}
  const UserRepository({
    required AuthenticationClient authenticationClient,
    required UserStorage storage,
  })  : _authenticationClient = authenticationClient,
        _storage = storage;

  final AuthenticationClient _authenticationClient;
  final UserStorage _storage;

  /// Stream of [User] which will emit the current user when
  /// the authentication state or the subscription plan changes.
  ///
  Stream<User> get user => _authenticationClient.user
      .map((user) => User.fromAuthenticationUser(authenticationUser: user));

  /// Starts the Sign In with Google Flow.
  ///
  /// Throws a [LogInWithGoogleCanceled] if the flow is canceled by the user.
  /// Throws a [LogInWithGoogleFailure] if an exception occurs.
  Future<void> logInWithGoogle() async {
    try {
      await _authenticationClient.logInWithGoogle();
    } on LogInWithGoogleFailure {
      rethrow;
    } on LogInWithGoogleCanceled {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LogInWithGoogleFailure(error), stackTrace);
    }
  }

  /// Signs in with the provided [email] and [password].
  ///
  /// Throws a [LogInWithPasswordFailure] if an exception occurs.
  Future<void> logInWithPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _authenticationClient.logInWithPassword(
        email: email,
        password: password,
      );
    } on LogInWithPasswordFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LogInWithPasswordFailure(error), stackTrace);
    }
  }

  /// Signs up with the provided [email] and [password].
  ///
  /// Throws a [SignUpWithPasswordCanceled] if the flow is canceled by the user.
  /// Throws a [SignUpWithPasswordFailure] if an exception occurs.
  Future<void> signUpWithPassword({
    required String password,
    required String email,
    required String username,
    String? photo,
  }) async {
    try {
      await _authenticationClient.signUpWithPassword(
        email: email,
        password: password,
        username: username,
      );
    } on SignUpWithPasswordFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(SignUpWithPasswordFailure(error), stackTrace);
    }
  }

  /// Signs out the current user which will emit
  /// [User.anonymous] from the [user] Stream.
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  Future<void> logOut() async {
    try {
      await _authenticationClient.logOut();
    } on LogOutFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LogOutFailure(error), stackTrace);
    }
  }

  /// Updates the current user profile.
  Future<void> updateProfile({
    String? username,
  }) async {
    try {
      await _authenticationClient.updateProfile(username: username);
    } on UpdateProfileFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(UpdateProfileFailure(error), stackTrace);
    }
  }

  /// Updates the current user profile.
  Future<void> updateEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _authenticationClient.updateEmail(email: email, password: password);
    } on UpdateEmailFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(UpdateEmailFailure(error), stackTrace);
    }
  }

  /// Deletes the current user account.
  Future<void> deleteAccount() async {
    try {
      await _authenticationClient.deleteAccount();
    } on DeleteAccountFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(DeleteAccountFailure(error), stackTrace);
    }
  }

  /// Broadcasts user location value from User Storage.
  ///
  /// * Initial value comes from persisted local storage.
  Stream<Location> currentLocation() => _storage.userLocation();

  /// Fetches user location value from User Storage.
  Location fetchCurrentLocation() => _storage.getUserLocation();

  /// Clears user location value in User Storage.
  Future<void> clearCurrentLocation() => _storage.clearUserLocation();

  /// Changes user location value in User Storage and emits new value
  /// to [currentLocation] stream.
  ///
  /// * New location is persisted in local storage.
  Future<void> changeLocation({required Location location}) async {
    try {
      await _storage.setUserLocation(location: location);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(ChangeUserLocationFailure(error), stackTrace);
    }
  }
}
