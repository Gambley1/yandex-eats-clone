import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_food_delivery_clone/src/auth/login/login.dart';

class LoginFormListener extends StatelessWidget {
  const LoginFormListener({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (p, c) => p.submissionStatus != c.submissionStatus,
      listener: (context, state) {
        final status = state.submissionStatus;
        if (status.isSuccess) {
          return context.closeSnackBars();
        }

        if (status.isTimeoutError || status.isNetworkError) {
          final (:title, :solution) = switch ('') {
            _ when status.isNetworkError => (
                title: 'Ran out of time',
                solution: 'Try again later'
              ),
            _ => (
                title: 'Network connection failed',
                solution: 'Try to reconnect your wifi'
              ),
          };
          return context.showSnackBar(
            title,
            duration: const Duration(days: 1),
            solution: solution,
            dismissDirection: DismissDirection.none,
          );
        }
        final snackMessage = switch ('') {
          _ when status.isInvalidCredentialsError =>
            'Invalid email and/or password.',
          _ when status.isApiMalformedError || status.isApiRequestError =>
            'Internal server error.',
          _ when status.isUserNotFound => 'User with this email not found.',
          _ when status.isError => 'Something went wrong!',
          _ => null,
        };
        if (snackMessage == null) return;
        context.showSnackBar(snackMessage);
      },
      child: child,
    );
  }
}
