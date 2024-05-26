import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/login/login.dart';
import 'package:papa_burger/src/sign_up/sign_up.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      resizeToAvoidBottomInset: true,
      releaseFocus: true,
      body: AppConstrainedScrollView(
        child: Column(
          children: [
            const WelcomeImage(),
            const SizedBox(height: AppSpacing.lg),
            const SignUpForm(),
            const SizedBox(height: AppSpacing.md),
            const Spacer(),
            SignUpFooter(
              text: 'Sign in',
              onTap: () {
                context.read<SignUpCubit>().reset();
                context.pushReplacementNamed(AppRoutes.login.name);
              },
            ),
          ],
        ),
      ),
    );
  }
}
