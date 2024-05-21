import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart' show Formz, FormzStatusX;
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/models/models.dart';
import 'package:papa_burger/src/services/repositories/user/user.dart';
import 'package:papa_burger_server/api.dart' as server;

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const LoginState.initial());

  final UserRepository _userRepository;

  void onEmailChanged(String newValue) {
    final previousScreenState = state;
    final previousEmailState = previousScreenState.email;
    final shouldValidate = previousEmailState.invalid;
    final newEmailState =
        shouldValidate ? Email.dirty(newValue) : Email.pure(newValue);

    final newScreenState = state.copyWith(
      email: newEmailState,
    );

    emit(newScreenState);
  }

  void onEmailUnfocused() {
    final previousScreenState = state;
    final previousEmailState = previousScreenState.email;
    final previousEmailValue = previousEmailState.value;

    final newEmailState = Email.dirty(
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
    final newPasswordState =
        shouldValidate ? Password.pure(newValue) : Password.dirty(newValue);

    final newScreenState = state.copyWith(
      password: newPasswordState,
    );

    emit(newScreenState);
  }

  void onPasswordUnfocused() {
    final previousScreenState = state;
    final previousPasswordState = previousScreenState.password;
    final previousPasswordValue = previousPasswordState.value;

    final newPasswordState = Password.pure(
      previousPasswordValue,
    );
    final newScreenState = previousScreenState.copyWith(
      password: newPasswordState,
    );
    emit(newScreenState);
  }

  void onLogOut() {
    const email = Email.pure();
    const password = Password.dirty();
    final newState = state.copyWith(
      email: email,
      password: password,
      submissionStatus: SubmissionStatus.idle,
    );
    emit(newState);
    _userRepository.logout();
  }

  void idle() {
    const email = Email.pure();
    const password = Password.dirty();
    final newState = state.copyWith(
      email: email,
      password: password,
      submissionStatus: SubmissionStatus.idle,
    );
    emit(newState);
  }

  Future<void> onSubmit() async {
    final email = Email.dirty(state.email.value);
    final password = Password.pure(state.password.value);
    final isFormValid = Formz.validate([email, password]).isValid;

    final newState = state.copyWith(
      email: email,
      password: password,
      submissionStatus: isFormValid ? SubmissionStatus.inProgress : null,
    );

    emit(newState);

    if (!isFormValid) {
      return;
    }
    try {
      await _userRepository.login(email.value, password.value);
      final newState = state.copyWith(
        submissionStatus: SubmissionStatus.success,
      );

      emit(newState);
    } catch (e) {
      logE(e);

      if (e is TimeoutException) {
        final newState = state.copyWith(
          submissionStatus: SubmissionStatus.timeoutError,
        );
        emit(newState);
      }

      if (e is server.NetworkApiException) {
        logE(e.message);
        final newState = state.copyWith(
          submissionStatus: SubmissionStatus.networkError,
        );
        emit(newState);
      }

      if (e is server.ApiClientMalformedResponse) {
        logE(e.error);
        final newState = state.copyWith(
          submissionStatus: SubmissionStatus.apiMalformedError,
        );

        emit(newState);
      }

      if (e is server.ApiClientRequestFailure) {
        logE((body: e.body, statusCode: e.statusCode));
        final newState = state.copyWith(
          submissionStatus: SubmissionStatus.apiMalformedError,
        );

        emit(newState);
      }

      if (e is server.InvalidCredentialsApiException) {
        logE(e.message);
        final newState = state.copyWith(
          submissionStatus: SubmissionStatus.invalidCredentialsError,
        );

        emit(newState);
      }

      if (e is server.UserNotFoundApiException) {
        logE(e.message);
        final newState = state.copyWith(
          submissionStatus: SubmissionStatus.userNotFound,
        );

        emit(newState);
      }
    }
  }
}
