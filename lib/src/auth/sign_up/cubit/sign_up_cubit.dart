import 'dart:async';

import 'package:bloc/bloc.dart' show Cubit;
import 'package:equatable/equatable.dart';
import 'package:form_fields/form_fields.dart';
import 'package:user_repository/user_repository.dart';
import 'package:yandex_food_api/api.dart' as api;
import 'package:yandex_food_delivery_clone/src/auth/login/cubit/login_cubit.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const SignUpState());

  final UserRepository _userRepository;
  
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
      await _userRepository.signUpWithPassword(
        username: username,
        email: email,
        password: password,
      );

      emit(state.copyWith(submissionStatus: SubmissionStatus.success));
    } catch (error, stackTrace) {
      addError(error, stackTrace);

      final submissionStatus = switch (error) {
        final TimeoutException _ => SubmissionStatus.timeoutError,
        final api.EmailAlreadyRegisteredApiException _ =>
          SubmissionStatus.emailAlreadyRegistered,
        _ => SubmissionStatus.genericError,
      };
      emit(state.copyWith(submissionStatus: submissionStatus));
    }
  }
}
