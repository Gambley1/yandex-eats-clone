import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:yandex_food_api/client.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required User user,
    required UserRepository userRepository,
    required NotificationsRepository notificationsRepository,
  })  : _userRepository = userRepository,
        _notificationsRepository = notificationsRepository,
        super(
          user.isAnonymous
              ? const AppState.unauthenticated()
              : AppState.authenticated(user),
        ) {
    on<AppUserChanged>(_onUserChanged);
    on<AppUserLocationChanged>(_onUserLocationChanged);
    on<AppUpdateAccountRequested>(_onAccountUpdateRequested);
    on<AppUpdateAccountEmailRequested>(_onUpdateAccountRequested);
    on<AppLogoutRequested>(_onLogoutRequested);
    on<AppDeleteAccountRequested>(_onDeleteAccountRequested);

    _userSubscription =
        userRepository.user.listen(_userChanged, onError: addError);
    _userLocationSubscription = userRepository
        .currentLocation()
        .listen(_userLocationChanged, onError: addError);
  }

  final UserRepository _userRepository;
  final NotificationsRepository _notificationsRepository;

  StreamSubscription<User>? _userSubscription;
  StreamSubscription<Location>? _userLocationSubscription;

  void _userChanged(User user) => add(AppUserChanged(user));

  void _userLocationChanged(Location location) =>
      add(AppUserLocationChanged(location));

  void _onUserChanged(AppUserChanged event, Emitter<AppState> emit) {
    final user = event.user;

    Future<void> authenticate() async {
      emit(AppState.authenticated(user));

      try {
        await _notificationsRepository.toggleNotifications(enable: true);
      } catch (error, stackTrace) {
        addError(error, stackTrace);
      }
    }

    switch (state.status) {
      case AppStatus.onboardingRequired:
      case AppStatus.authenticated:
      case AppStatus.unauthenticated:
        return user.isAnonymous
            ? emit(const AppState.unauthenticated())
            : authenticate();
    }
  }

  Future<void> _onUserLocationChanged(
    AppUserLocationChanged event,
    Emitter<AppState> emit,
  ) async {
    if (state.location == event.location) return;
    emit(state.copyWith(location: event.location));
  }

  Future<void> _onAccountUpdateRequested(
    AppUpdateAccountRequested event,
    Emitter<AppState> emit,
  ) async {
    try {
      await _userRepository.updateProfile(username: event.username);
    } catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  Future<void> _onUpdateAccountRequested(
    AppUpdateAccountEmailRequested event,
    Emitter<AppState> emit,
  ) async {
    try {
      await _userRepository.updateEmail(
        email: event.email,
        password: event.password,
      );
    } catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  void _onLogoutRequested(
    AppLogoutRequested event,
    Emitter<AppState> emit,
  ) {
    unawaited(_userRepository.logOut());
  }

  Future<void> _onDeleteAccountRequested(
    AppDeleteAccountRequested event,
    Emitter<AppState> emit,
  ) async {
    try {
      await _userRepository.deleteAccount();
    } catch (error, stackTrace) {
      await _userRepository.logOut();
      addError(error, stackTrace);
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    _userLocationSubscription?.cancel();
    return super.close();
  }
}
