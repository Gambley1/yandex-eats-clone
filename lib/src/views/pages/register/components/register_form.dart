import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocBuilder, BlocConsumer, ReadContext;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/models/models.dart';
import 'package:papa_burger/src/views/pages/login/components/show_password_controller/show_password_cubit.dart';
import 'package:papa_burger/src/views/pages/login/state/login_cubit.dart';
import 'package:papa_burger/src/views/pages/register/state/register_cubit.dart';
import 'package:papa_burger/src/views/widgets/widgets.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _usernameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final cubit = context.read<RegisterCubit>();
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
    _usernameFocusNode.addListener(() {
      if (!_usernameFocusNode.hasFocus) {
        cubit.onNameUnfocused();
      }
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _usernameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (_, state) {
        final malformed =
            state.submissionStatus == SubmissionStatus.apiMalformedError;
        final requestFailed =
            state.submissionStatus == SubmissionStatus.apiRequestError;
        final timeoutError =
            state.submissionStatus == SubmissionStatus.timeoutError;
        final emailAlreadyInUse =
            state.submissionStatus == SubmissionStatus.emailAlreadyRegistered;
        final success = state.submissionStatus == SubmissionStatus.success;

        const alreadyRegistered = 'Email already registered.';
        const malformedException = 'Something went wrong. Try again later.';
        const requestFailedException =
            'Request to the server has failed. Please try again later.';
        const ranOutOfTime = 'Client ran out of time. Pleas try again later';

        if (success) {
          context
            ..navigateToGoogleMapViewAfterRegisterOrLogin()
            ..closeSnackBars();
        }
        if (malformed) {
          context.showSnackBar(malformedException);
        }
        if (requestFailed) {
          context.showSnackBar(requestFailedException);
        }
        if (timeoutError) {
          context.showSnackBar(ranOutOfTime);
        }
        if (emailAlreadyInUse) {
          context.showSnackBar(alreadyRegistered);
        }
      },
      listenWhen: (p, c) => p.submissionStatus != c.submissionStatus,
      builder: (context, state) {
        final emailError = state.email.invalid ? state.email.error : null;
        final passwordError =
            state.password.invalid ? state.password.error : null;
        final usernameError = state.name.invalid ? state.name.error : null;
        final isSubmissionInProgress =
            state.submissionStatus == SubmissionStatus.inProgress;

        final cubit = context.read<RegisterCubit>();
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: kDefaultHorizontalPadding + 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Register',
                style: context.headlineMedium,
              ),
              const SizedBox(height: 16),
              AppTextField(
                labelText: 'User name',
                focusNode: _usernameFocusNode,
                prefixIcon: const Icon(FontAwesomeIcons.user),
                autoCorrect: false,
                enabled: !isSubmissionInProgress,
                textInputAction: TextInputAction.next,
                onChanged: cubit.onNameChanged,
                errorText: usernameError == null
                    ? null
                    : (usernameError == UsernameValidationError.empty
                        ? "User name can't be empty."
                        : 'User name is not valid.'),
                border: outlinedBorder(6),
              ),
              const SizedBox(height: 16),
              AppTextField(
                labelText: 'Email',
                focusNode: _emailFocusNode,
                prefixIcon: const Icon(Icons.email_outlined),
                autoCorrect: false,
                enabled: !isSubmissionInProgress,
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
                  return AppTextField(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    focusNode: _passwordFocusNode,
                    obscureText: isTextObscured,
                    suffixIcon: CustomIcon(
                      size: 20,
                      type: IconType.iconButton,
                      onPressed: () => !isSubmissionInProgress
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
                    enabled: !isSubmissionInProgress,
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
              const SizedBox(height: 24),
              if (isSubmissionInProgress)
                ExpandedElevatedButton.inProgress(
                  backgroundColor: Colors.transparent,
                  radius: 16,
                  textColor: Colors.white,
                )
              else
                ExpandedElevatedButton(
                  backgroundColor: Colors.blue,
                  label: 'Register',
                  onTap: cubit.onRegisterSubmit,
                ),
            ],
          ),
        );
      },
    );
  }
}
