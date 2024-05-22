import 'dart:async';

import 'package:bloc/bloc.dart' show Cubit;
import 'package:equatable/equatable.dart';
import 'package:papa_burger/src/models/models.dart';
import 'package:papa_burger/src/services/repositories/user/user.dart';
import 'package:papa_burger/src/views/pages/login/cubit/login_cubit.dart';
import 'package:papa_burger_server/api.dart' as server;

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const SignUpState());

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

  void reset() {
    const password = Password.pure();
    const name = Username.pure();
    final newState = state.copyWith(
      password: password,
      name: name,
      submissionStatus: SubmissionStatus.idle,
    );
    emit(newState);
  }

  Future<void> onSubmit({
    required String username,
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(submissionStatus: SubmissionStatus.inProgress));

    try {
      await _userRepository.signUp(username, email, password);

      emit(state.copyWith(submissionStatus: SubmissionStatus.success));
    } catch (error, stackTrace) {
      addError(error, stackTrace);

      final submissionStatus = switch (error) {
        final TimeoutException _ => SubmissionStatus.timeoutError,
        final server.EmailAlreadyRegisteredApiException _ =>
          SubmissionStatus.emailAlreadyRegistered,
        final server.ApiClientMalformedResponse _ =>
          SubmissionStatus.apiMalformedError,
        final server.ApiClientRequestFailure _ =>
          SubmissionStatus.apiMalformedError,
        _ => SubmissionStatus.genericError,
      };
      emit(state.copyWith(submissionStatus: submissionStatus));
    }
  }
}
