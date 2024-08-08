import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:form_fields/form_fields.dart';
import 'package:user_repository/user_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const LoginState.initial());

  final UserRepository _userRepository;

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
      await _userRepository.logInWithPassword(email: email, password: password);

      emit(state.copyWith(submissionStatus: SubmissionStatus.success));
    } catch (error, stackTrace) {
      addError(error, stackTrace);

      final submissionStatus = switch (error) {
        final TimeoutException _ => SubmissionStatus.timeoutError,
        _ => SubmissionStatus.error,
      };
      emit(state.copyWith(submissionStatus: submissionStatus));
    }
  }
}
