import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocBuilder, ReadContext, BlocConsumer;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;
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
    Key? key,
  }) : super(key: key);

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
  const _LogInForm({
    Key? key,
  }) : super(key: key);

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
          context.navigateToMainPage();
          return;
        }

        final hasSubmisionError = state.submissionStatus ==
                SubmissionStatus.genericError ||
            state.submissionStatus == SubmissionStatus.invalidCredentialsError;

        final emailAlreadyInUse =
            state.submissionStatus == SubmissionStatus.emailAlreadyInUse;

        final userNotFound =
            state.submissionStatus == SubmissionStatus.userNotFound;

        if (hasSubmisionError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              state.submissionStatus == SubmissionStatus.invalidCredentialsError
                  ? const SnackBar(
                      content: Text(
                        'Invalid email and/or password',
                      ),
                    )
                  : const SnackBar(
                      content: Text(
                        'User not found',
                      ),
                    ),
            );
        }

        if (emailAlreadyInUse) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: KText(
                  text: 'Email already in use!',
                ),
              ),
            );
        }

        if (userNotFound) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: KText(
                  text: 'User not found!',
                ),
              ),
            );
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
              text: "Login",
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
                      ? 'Email can\'t be empty.'
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
                                .handleShowPassword(false)
                            : context
                                .read<ShowPasswordCubit>()
                                .handleShowPassword(true)
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
                          ? 'Password can\'t be empty.'
                          : 'Password is not valid.'),
                  border: outlinedBorder(6),
                );
              },
            ),
            const ForgotPassword(),
            isSubmissionInProggress
                ? ExpandedElevatedButton.inProgress(
                    backgroundColor: Colors.transparent,
                    label: '',
                    radius: 16,
                    textColor: Colors.white,
                  )
                : ExpandedElevatedButton(
                    backgroundColor: Colors.blue,
                    label: 'Login',
                    onTap: cubit.onSubmit,
                  ),
          ],
        );
      },
    );
  }
}
