part of 'login_cubit.dart';

enum SubmissionStatus {
  idle,
  inProgress,
  success,
  timeoutError,
  error;

  bool get isLoading => this == SubmissionStatus.inProgress;
  bool get isSuccess => this == SubmissionStatus.success;
  bool get isTimeoutError => this == SubmissionStatus.timeoutError;
  bool get isError => this == SubmissionStatus.error;
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
