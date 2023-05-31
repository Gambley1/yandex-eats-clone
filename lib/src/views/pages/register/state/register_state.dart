part of 'register_cubit.dart';

class RegisterState extends Equatable {
  const RegisterState({
    this.name = const Username.unvalidated(),
    this.email = const Email.unvalidated(),
    this.password = const Password.unvalidated(),
    this.profilePicture = '',
    this.submissionStatus = SubmissionStatus.idle,
  });

  final Email email;
  final Password password;
  final Username name;
  final SubmissionStatus submissionStatus;
  final String? profilePicture;

  RegisterState copyWith({
    Email? email,
    Password? password,
    Username? name,
    String? profilePicture,
    SubmissionStatus? submissionStatus,
  }) =>
      RegisterState(
        email: email ?? this.email,
        password: password ?? this.password,
        name: name ?? this.name,
        profilePicture: profilePicture ?? this.profilePicture,
        submissionStatus: submissionStatus ?? this.submissionStatus,
      );

  @override
  List<Object?> get props => <Object?>[
        email,
        password,
        name,
        profilePicture,
        submissionStatus,
      ];
}
