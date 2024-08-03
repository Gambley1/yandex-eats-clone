part of 'app_bloc.dart';

/// {@template app_status}
/// The status of the application. Used to determine which page to show when
/// the application is started.
/// {@endtemplate}
enum AppStatus {
  /// The user is authenticated. Show `MainPage`.
  authenticated,

  /// The user is not authenticated or the authentication status is unknown.
  /// Show `AuthPage`.
  unauthenticated,

  /// The authentication status is unknown. Show `SplashPage`.
  onboardingRequired,
}

class AppState extends Equatable {
  const AppState({
    required this.status,
    this.user = User.anonymous,
    this.location = const Location.undefined(),
  });

  const AppState.authenticated(User user)
      : this(status: AppStatus.authenticated, user: user);

  const AppState.onboardingRequired(User user)
      : this(
          status: AppStatus.onboardingRequired,
          user: user,
        );

  const AppState.unauthenticated()
      : this(status: AppStatus.unauthenticated, user: User.anonymous);

  final AppStatus status;
  final User user;
  final Location location;

  AppState copyWith({
    User? user,
    AppStatus? status,
    Location? location,
  }) {
    return AppState(
      user: user ?? this.user,
      status: status ?? this.status,
      location: location ?? this.location,
    );
  }

  @override
  List<Object> get props => [status, user, location];
}
