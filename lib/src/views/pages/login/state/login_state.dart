part of 'login_cubit.dart';

enum SubmissionStatus {
  idle,
  inProgress,
  success,
  emailAlreadyRegistered,
  genericError,
  invalidCredentialsError,
  apiMalformedError,
  apiRequestError,
  userNotFound,
  timeoutError,
  networkError,
}

class LoginState {
  const LoginState._({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.submissionStatus = SubmissionStatus.idle,
  });

  const LoginState.initial() : this._();

  final Email email;
  final Password password;
  final SubmissionStatus submissionStatus;

  LoginState copyWith({
    Email? email,
    Password? password,
    SubmissionStatus? submissionStatus,
  }) {
    return LoginState._(
      email: email ?? this.email,
      password: password ?? this.password,
      submissionStatus: submissionStatus ?? this.submissionStatus,
    );
  }
}
