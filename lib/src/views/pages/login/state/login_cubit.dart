import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:papa_burger/src/restaurant.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required this.userRepository,
  }) : super(
          const LoginState(),
        );

  final UserRepository userRepository;

  void onEmailChanged(String newValue) {
    final previousScreenState = state;
    final previousEmailState = previousScreenState.email;
    final shouldValidate = previousEmailState.invalid;
    final newEmailState = shouldValidate
        ? Email.validated(
            newValue,
          )
        : Email.unvalidated(
            newValue,
          );

    final newScreenState = state.copyWith(
      email: newEmailState,
    );

    emit(newScreenState);
  }

  void onEmailUnfocused() {
    final previousScreenState = state;
    final previousEmailState = previousScreenState.email;
    final previousEmailValue = previousEmailState.value;

    final newEmailState = Email.validated(
      previousEmailValue,
    );
    final newScreenState = previousScreenState.copyWith(
      email: newEmailState,
    );
    emit(newScreenState);
  }

  void onPasswordChanged(String newValue) {
    final previousScreenState = state;
    final previousPasswordState = previousScreenState.password;
    final shouldValidate = previousPasswordState.invalid;
    final newPasswordState = shouldValidate
        ? Password.validated(
            newValue,
          )
        : Password.unvalidated(
            newValue,
          );

    final newScreenState = state.copyWith(
      password: newPasswordState,
    );

    emit(newScreenState);
  }

  void onPasswordUnfocused() {
    final previousScreenState = state;
    final previousPasswordState = previousScreenState.password;
    final previousPasswordValue = previousPasswordState.value;

    final newPasswordState = Password.validated(
      previousPasswordValue,
    );
    final newScreenState = previousScreenState.copyWith(
      password: newPasswordState,
    );
    emit(newScreenState);
  }

  void onLogOut() {
    userRepository.logout();
  }

  void onSubmit() {
    final email = Email.validated(state.email.value);
    final password = Password.validated(state.password.value);

    final isFormValid = Formz.validate([
      email,
      password,
    ]).isValid;

    final newState = state.copyWith(
      email: email,
      password: password,
      submissionStatus: isFormValid ? SubmissionStatus.inProgress : null,
    );

    emit(newState);

    if (isFormValid) {
      try {
        userRepository.logIn(
          email.value,
          password.value,
        );
        final newState = state.copyWith(
          submissionStatus: SubmissionStatus.success,
        );
        emit(newState);
      } catch (error) {
        logger.e(error);
        // final newState = state.copyWith(
        //   submissionStatus: error is InvalidCredentialsException
        //       ? SubmissionStatus.invalidCredentialsError
        //       : error is EmailAlreadyRegisteredException
        //           ? SubmissionStatus.emailAlreadyInUse
        //           : SubmissionStatus.genericError,
        // );
        final newState = state.copyWith(
          submissionStatus: error is EmailAlreadyRegisteredException
              ? SubmissionStatus.emailAlreadyInUse
              : null,
        );
        emit(newState);
      }
    }
  }
}
