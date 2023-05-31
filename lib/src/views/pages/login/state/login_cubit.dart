import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:formz/formz.dart' show Formz, FormzStatusX;
import 'package:papa_burger/src/restaurant.dart'
    show
        Email,
        LocalStorage,
        LocationNotifier,
        MainPageService,
        Password,
        UserRepository,
        logger;
import 'package:papa_burger_server/api.dart' as server;

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required this.userRepository,
  }) : super(
          const LoginState(),
        );

  final UserRepository userRepository;

  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  Future<void> onSubmit() async {
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
      logger.w('Trying to login');

      try {
        final localStorage = LocalStorage.instance;
        final mainPageService = MainPageService();
        final locationNotifier = LocationNotifier();

        final userCredentical = await _auth.signInWithEmailAndPassword(
          email: email.value,
          password: password.value,
        );
        final firebaseUser = userCredentical.user;

        localStorage.saveCookieUserCredentials(
          firebaseUser!.uid,
          firebaseUser.email!,
          firebaseUser.displayName ?? 'Unknown',
        );

        await mainPageService.mainBloc.fetchAllRestaurantsByLocation();
        await mainPageService.mainBloc.refresh();
        await locationNotifier.getLocationFromFirerstoreDB();

        final newState =
            state.copyWith(submissionStatus: SubmissionStatus.success);

        emit(newState);
      } on FirebaseException catch (e) {
        logger.e('${e.message}');
        final newState =
            state.copyWith(submissionStatus: SubmissionStatus.userNotFound);

        emit(newState);
      }
    }
  }

  Future<void> onSubmitTest() async {
    final email = Email.validated(state.email.value);
    final password = Password.validated(state.password.value);
    final isFormValid = Formz.validate([email, password]).isValid;

    final newState = state.copyWith(
      email: email,
      password: password,
      submissionStatus: isFormValid ? SubmissionStatus.inProgress : null,
    );

    emit(newState);

    if (isFormValid) {
      logger.i('Test try to login user.');
      try {
        final apiClient = server.ApiClient();
        final localStorage = LocalStorage.instance;
        final mainPageService = MainPageService();
        // final locationNotifier = LocationNotifier();
        final user = await apiClient.login(email.value, password.value);
        logger.i('User: ${user?.toMap()}');

        if (user != null) {
          final newState = state.copyWith(
            submissionStatus: SubmissionStatus.success,
          );
          localStorage.saveUser(user.toJson());
          await mainPageService.mainBloc.fetchAllRestaurantsByLocation();
          await mainPageService.mainBloc.refresh();
          // await locationNotifier.getLocationFromFirerstoreDB();

          emit(newState);
        } else {
          final newState = state.copyWith(
            submissionStatus: SubmissionStatus.invalidCredentialsError,
          );

          emit(newState);
        }
      } catch (e) {
        logger.e(e);

        if (e is server.ApiClientMalformedResponse) {
          logger.e(e.error);
          final newState = state.copyWith(
            submissionStatus: SubmissionStatus.apiMalformedError,
          );

          emit(newState);
        }

        if (e is server.ApiClientRequestFailure) {
          logger.e(e.body, e.statusCode);
          final newState = state.copyWith(
            submissionStatus: SubmissionStatus.apiMalformedError,
          );

          emit(newState);
        }

        if (e is server.InvalidCredentialsException) {
          logger.e(e.message);
          final newState = state.copyWith(
            submissionStatus: SubmissionStatus.invalidCredentialsError,
          );

          emit(newState);
        }

        if (e is server.UserNotFoundException) {
          logger.e(e.message);
          final newState = state.copyWith(
            submissionStatus: SubmissionStatus.userNotFound,
          );

          emit(newState);
        }
      }
    }
  }
}
