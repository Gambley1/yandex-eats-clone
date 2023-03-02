part of 'login_cubit.dart';

enum SubmissionStatus {
  idle,
  inProgress,
  success,
  genericError,
  invalidCredentialsError,
}

class LoginState {
  const LoginState({
    this.email = const Email.unvalidated(),
    this.password = const Password.unvalidated(),
    this.submissionStatus = SubmissionStatus.idle,
  });

  final Email email;
  final Password password;
  final SubmissionStatus submissionStatus;

  LoginState copyWith({
    Email? email,
    Password? password,
    SubmissionStatus? submissionStatus,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      submissionStatus: submissionStatus ?? this.submissionStatus,
    );
  }
}
