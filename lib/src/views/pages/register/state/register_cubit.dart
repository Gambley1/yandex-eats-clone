import 'dart:async';

import 'package:bloc/bloc.dart' show Cubit;
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart' show Formz, FormzStatusX;
import 'package:papa_burger/isolates.dart';
import 'package:papa_burger/src/config/utils/app_constants.dart';
import 'package:papa_burger/src/restaurant.dart'
    show
        Email,
        LocalStorage,
        MainPageService,
        Password,
        SubmissionStatus,
        Username,
        logger;
import 'package:papa_burger_server/api.dart' as server;

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(const RegisterState());

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

  void onNameChanged(String newValue) {
    final previousScreenState = state;
    final previousEmailState = previousScreenState.name;
    final shouldValidate = previousEmailState.invalid;
    final newEmailState = shouldValidate
        ? Username.validated(
            newValue,
          )
        : Username.unvalidated(
            newValue,
          );

    final newScreenState = state.copyWith(
      name: newEmailState,
    );

    emit(newScreenState);
  }

  void onNameUnfocused() {
    final previousScreenState = state;
    final previousEmailState = previousScreenState.name;
    final previousEmailValue = previousEmailState.value;

    final newEmailState = Username.validated(
      previousEmailValue,
    );
    final newScreenState = previousScreenState.copyWith(
      name: newEmailState,
    );
    emit(newScreenState);
  }

  void idle() {
    const email = Email.unvalidated();
    const password = Password.unvalidated();
    const name = Username.unvalidated();
    final newState = state.copyWith(
      email: email,
      password: password,
      name: name,
      submissionStatus: SubmissionStatus.idle,
    );
    emit(newState);
  }

  Future<void> onRegisterSubmit() async {
    final email = Email.validated(state.email.value);
    final password = Password.validated(state.password.value);
    final name = Username.validated(state.name.value);

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

    if (isFormValid) {
      logger.i('Try to register user.');

      try {
        final apiClient = server.ApiClient();
        final localStorage = LocalStorage.instance;
        final mainPageService = MainPageService();

        final user = await apiClient
            .register(
              name.value,
              email.value,
              password.value,
            )
            .timeout(defaultTimeout);

        if (user != null) {
          final newState = state.copyWith(
            submissionStatus: SubmissionStatus.success,
          );
          localStorage
            ..saveUser(user.toJson())
            ..saveCookieUserCredentials(
              user.uid,
              user.email,
              user.name,
            );
          await mainPageService.mainBloc.fetchAllRestaurantsByLocation();
          await mainPageService.mainBloc.refresh();
          await useRestaurantsIsolate();
          // await locationNotifier.getLocationFromFirerstoreDB();

          emit(newState);
        }

        final newState = state.copyWith(
          submissionStatus: SubmissionStatus.invalidCredentialsError,
        );

        emit(newState);
      } catch (e) {
        logger.e(e);

        if (e is TimeoutException) {
          logger.e(e.message);
          final newState = state.copyWith(
            submissionStatus: SubmissionStatus.timeoutError,
          );
          emit(newState);
        }

        if (e is server.EmailAlreadyRegisteredApiException) {
          logger.e(e.message);
          final newState = state.copyWith(
            submissionStatus: SubmissionStatus.emailAlreadyRegistered,
          );

          emit(newState);
        }

        final newState = state.copyWith(
          submissionStatus: SubmissionStatus.genericError,
        );

        emit(newState);
      }
    }
  }
}
