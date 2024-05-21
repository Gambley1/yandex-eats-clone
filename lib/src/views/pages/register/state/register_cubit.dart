import 'dart:async';

import 'package:bloc/bloc.dart' show Cubit;
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart' show Formz, FormzStatusX;
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/models/models.dart';
import 'package:papa_burger/src/services/repositories/user/user.dart';
import 'package:papa_burger/src/views/pages/login/state/login_cubit.dart';
import 'package:papa_burger_server/api.dart' as server;

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const RegisterState());

  final UserRepository _userRepository;

  void onEmailChanged(String newValue) {
    final previousScreenState = state;
    final previousEmailState = previousScreenState.email;
    final shouldValidate = previousEmailState.invalid;
    final newEmailState =
        shouldValidate ? Email.dirty(newValue) : Email.pure(newValue);

    final newScreenState = state.copyWith(email: newEmailState);

    emit(newScreenState);
  }

  void onEmailUnfocused() {
    final previousScreenState = state;
    final previousEmailState = previousScreenState.email;
    final previousEmailValue = previousEmailState.value;

    final newEmailState = Email.dirty(previousEmailValue);
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
        shouldValidate ? Password.dirty(newValue) : Password.pure(newValue);

    final newScreenState = state.copyWith(
      password: newPasswordState,
    );

    emit(newScreenState);
  }

  void onPasswordUnfocused() {
    final previousScreenState = state;
    final previousPasswordState = previousScreenState.password;
    final previousPasswordValue = previousPasswordState.value;

    final newPasswordState = Password.dirty(previousPasswordValue);
    final newScreenState =
        previousScreenState.copyWith(password: newPasswordState);
    emit(newScreenState);
  }

  void onNameChanged(String newValue) {
    final previousScreenState = state;
    final previousEmailState = previousScreenState.name;
    final shouldValidate = previousEmailState.invalid;
    final newEmailState =
        shouldValidate ? Username.dirty(newValue) : Username.pure(newValue);

    final newScreenState = state.copyWith(
      name: newEmailState,
    );

    emit(newScreenState);
  }

  void onNameUnfocused() {
    final previousScreenState = state;
    final previousEmailState = previousScreenState.name;
    final previousEmailValue = previousEmailState.value;

    final newEmailState = Username.dirty(previousEmailValue);
    final newScreenState = previousScreenState.copyWith(
      name: newEmailState,
    );
    emit(newScreenState);
  }

  void idle() {
    const password = Password.pure();
    const name = Username.pure();
    final newState = state.copyWith(
      password: password,
      name: name,
      submissionStatus: SubmissionStatus.idle,
    );
    emit(newState);
  }

  Future<void> onRegisterSubmit() async {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final name = Username.dirty(state.name.value);

    final isFormValid = Formz.validate([
      email,
      password,
      name,
    ]).isValid;

    final newState = state.copyWith(
      email: email,
      password: password,
      name: name,
      submissionStatus: isFormValid ? SubmissionStatus.inProgress : null,
    );

    emit(newState);

    if (!isFormValid) {
      return;
    }
    try {
      await _userRepository.register(name.value, email.value, password.value);
      final newState = state.copyWith(
        submissionStatus: SubmissionStatus.success,
      );

      emit(newState);
    } catch (e) {
      logE(e);

      if (e is TimeoutException) {
        logE(e.message);
        final newState = state.copyWith(
          submissionStatus: SubmissionStatus.timeoutError,
        );
        emit(newState);
      }

      if (e is server.EmailAlreadyRegisteredApiException) {
        logE(e.message);
        final newState = state.copyWith(
          submissionStatus: SubmissionStatus.emailAlreadyRegistered,
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
        logE(e.body['error']);
        final newState = state.copyWith(
          submissionStatus: SubmissionStatus.apiRequestError,
        );

        emit(newState);
      }
    }
  }
}
