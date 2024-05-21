import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/views/pages/login/components/login_footer.dart';
import 'package:papa_burger/src/views/pages/login/components/login_image.dart';
import 'package:papa_burger/src/views/pages/register/components/register_form.dart';
import 'package:papa_burger/src/views/pages/register/state/register_cubit.dart';
import 'package:papa_burger/src/views/widgets/widgets.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      resizeToAvoidBottomInset: true,
      releaseFocus: true,
      body: ListView(
        children: [
          Column(
            children: [
              const LoginImage(),
              const RegisterForm(),
              const SizedBox(height: 16),
              LoginFooter(
                text: 'Sign in',
                onTap: () {
                  context.read<RegisterCubit>().idle();
                  context.navigateToLogin();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
