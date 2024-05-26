import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/sign_up/sign_up.dart';

class SignUpFormListener extends StatelessWidget {
  const SignUpFormListener({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (_, state) {
        final status = state.submissionStatus;

        const emailRegisteredMessage = 'Email already registered.';
        const apiMalformedMessage = 'Something went wrong. Try again later.';
        const apiRequestFailedMessage =
            'Request to the server has failed. Please try again later.';
        const timeoutMessage = 'Client ran out of time. Pleas try again later';

        if (status.isSuccess) {
          context
            ..pushReplacementNamed(AppRoutes.googleMap.name)
            ..closeSnackBars();
          return;
        }

        final snackMessage = switch ('') {
          _ when status.isApiMalformedError => apiMalformedMessage,
          _ when status.isApiRequestError => apiRequestFailedMessage,
          _ when status.isTimeoutError => timeoutMessage,
          _ when status.isEmailAlreadyRegistered => emailRegisteredMessage,
          _ when status.isError => 'Something went wrong!',
          _ => null,
        };
        if (snackMessage == null) return;
        context.showSnackBar(snackMessage);
      },
      listenWhen: (p, c) => p.submissionStatus != c.submissionStatus,
      child: child,
    );
  }
}
