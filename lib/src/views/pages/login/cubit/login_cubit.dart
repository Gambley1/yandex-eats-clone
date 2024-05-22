import 'dart:async';

import 'package:bloc/bloc.dart';
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

  void reset() {
    const email = Email.pure();
    const password = Password.dirty();
    final newState = state.copyWith(
      email: email,
      password: password,
      submissionStatus: SubmissionStatus.idle,
    );
    emit(newState);
  }

  Future<void> onSubmit({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(submissionStatus: SubmissionStatus.inProgress));

    try {
      await _userRepository.login(email, password);

      emit(state.copyWith(submissionStatus: SubmissionStatus.success));
    } catch (error, stackTrace) {
      addError(error, stackTrace);

      final submissionStatus = switch (error) {
        final TimeoutException _ => SubmissionStatus.timeoutError,
        final server.NetworkApiException _ => SubmissionStatus.networkError,
        final server.ApiClientMalformedResponse _ =>
          SubmissionStatus.apiMalformedError,
        final server.ApiClientRequestFailure _ =>
          SubmissionStatus.apiMalformedError,
        final server.InvalidCredentialsApiException _ =>
          SubmissionStatus.invalidCredentialsError,
        final server.UserNotFoundApiException _ =>
          SubmissionStatus.userNotFound,
        _ => SubmissionStatus.genericError,
      };
      emit(state.copyWith(submissionStatus: submissionStatus));
    }
  }
}
