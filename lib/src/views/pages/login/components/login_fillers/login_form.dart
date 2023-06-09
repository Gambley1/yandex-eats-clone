import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocBuilder, BlocConsumer, ReadContext;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;
import 'package:papa_burger/src/config/extensions/snack_bar_extension.dart';
import 'package:papa_burger/src/restaurant.dart'
    show
        AppInputText,
        CustomIcon,
        EmailValidationError,
        ExpandedElevatedButton,
        ForgotPassword,
        IconType,
        KText,
        LoginCubit,
        LoginState,
        NavigatorExtension,
        PasswordValidationError,
        ShowPasswordCubit,
        ShowPasswordState,
        SubmissionStatus,
        kDefaultHorizontalPadding,
        outlinedBorder;

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultHorizontalPadding + 12,
      ),
      child: _LogInForm(),
    );
  }
}

class _LogInForm extends StatefulWidget {
  const _LogInForm();

  @override
  State<_LogInForm> createState() => __LogInFormState();
}

class __LogInFormState extends State<_LogInForm> {
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final cubit = context.read<LoginCubit>();
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        cubit.onEmailUnfocused();
      }
    });
    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        cubit.onPasswordUnfocused();
      }
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listenWhen: (oldState, newState) =>
          oldState.submissionStatus != newState.submissionStatus,
      listener: (context, state) {
        if (state.submissionStatus == SubmissionStatus.success) {
          context..navigateToMainPage()..closeSnackBars();
        }
        final networkError =
            state.submissionStatus == SubmissionStatus.networkError;
        final invalidCredentials =
            state.submissionStatus == SubmissionStatus.invalidCredentialsError;
        final userNotFound =
            state.submissionStatus == SubmissionStatus.userNotFound;
        final apiMalformedError =
            state.submissionStatus == SubmissionStatus.apiMalformedError;
        final apiRequestError =
            state.submissionStatus == SubmissionStatus.apiRequestError;
        final genericError =
            state.submissionStatus == SubmissionStatus.genericError;

        if (networkError) {
          context.showSnackBar(
            'Network connection failed.',
            duration: const Duration(days: 1),
            solution: 'Try to recconect your wifi',
            dismissDirection: DismissDirection.none,
            snackBarAction: SnackBarAction(
              textColor: Colors.indigo.shade200,
              label: 'TRY AGAIN',
              onPressed: () {
                context.read<LoginCubit>().onSubmitTest();
              },
            ),
          );
        }
        if (invalidCredentials) {
          context.showSnackBar('Invalid email and/or password.');
        }
        if (apiMalformedError || apiRequestError) {
          context.showSnackBar('Internal server error.');
        }
        if (genericError) {
          context.showSnackBar('Something went wrong.');
        }
        if (userNotFound) {
          context.showSnackBar('User with this email not found.');
        }
      },
      builder: (context, state) {
        final emailError = state.email.invalid ? state.email.error : null;
        final passwordError =
            state.password.invalid ? state.password.error : null;
        final isSubmissionInProggress =
            state.submissionStatus == SubmissionStatus.inProgress;

        final cubit = context.read<LoginCubit>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const KText(
              text: 'Login',
              size: 24,
            ),
            const SizedBox(height: 16),
            AppInputText(
              // hintText: 'Email',
              labelText: 'Email',
              focusNode: _emailFocusNode,
              prefixIcon: const Icon(Icons.email_outlined),
              autoCorrect: false,
              enabled: !isSubmissionInProggress,
              textInputAction: TextInputAction.next,
              onChanged: cubit.onEmailChanged,
              errorText: emailError == null
                  ? null
                  : (emailError == EmailValidationError.empty
                      ? "Email can't be empty."
                      : 'Email is not valid.'),
              border: outlinedBorder(6),
            ),
            const SizedBox(height: 16),
            BlocBuilder<ShowPasswordCubit, ShowPasswordState>(
              builder: (context, state) {
                final isTextObscured = state.textObscure;
                return AppInputText(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outlined),
                  focusNode: _passwordFocusNode,
                  obscureText: isTextObscured,
                  suffixIcon: CustomIcon(
                    size: 20,
                    type: IconType.iconButton,
                    onPressed: () => !isSubmissionInProggress
                        ? isTextObscured == true
                            ? context
                                .read<ShowPasswordCubit>()
                                .handleShowPassword(showPassword: false)
                            : context
                                .read<ShowPasswordCubit>()
                                .handleShowPassword(showPassword: true)
                        : null,
                    icon: isTextObscured == true
                        ? FontAwesomeIcons.eyeLowVision
                        : FontAwesomeIcons.eye,
                  ),
                  enabled: !isSubmissionInProggress,
                  onChanged: cubit.onPasswordChanged,
                  errorText: passwordError == null
                      ? null
                      : (passwordError == PasswordValidationError.empty
                          ? "Password can't be empty."
                          : 'Password is not valid.'),
                  border: outlinedBorder(6),
                );
              },
            ),
            const ForgotPassword(),
            if (isSubmissionInProggress)
              ExpandedElevatedButton.inProgress(
                backgroundColor: Colors.transparent,
                radius: 16,
                textColor: Colors.white,
              )
            else
              ExpandedElevatedButton(
                backgroundColor: Colors.blue,
                label: 'Login',
                onTap: cubit.onSubmitTest,
              ),
          ],
        );
      },
    );
  }
}
