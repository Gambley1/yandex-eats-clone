part of 'sign_up_cubit.dart';

class SignUpState extends Equatable {
  const SignUpState({
    this.name = const Username.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.profilePicture = '',
    this.submissionStatus = SubmissionStatus.idle,
  });

  final Email email;
  final Password password;
  final Username name;
  final SubmissionStatus submissionStatus;
  final String? profilePicture;

  SignUpState copyWith({
    Email? email,
    Password? password,
    Username? name,
    String? profilePicture,
    SubmissionStatus? submissionStatus,
  }) =>
      SignUpState(
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
