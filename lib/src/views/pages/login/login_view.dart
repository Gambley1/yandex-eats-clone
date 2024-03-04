import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:papa_burger/src/config/extensions/extensions.dart';
import 'package:papa_burger/src/views/pages/login/components/login_footer.dart';
import 'package:papa_burger/src/views/pages/login/components/login_form.dart';
import 'package:papa_burger/src/views/pages/login/components/login_image.dart';
import 'package:papa_burger/src/views/pages/login/components/login_with_google_and_facebook.dart';
import 'package:papa_burger/src/views/pages/login/state/login_cubit.dart';
import 'package:papa_burger/src/views/widgets/widgets.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      resizeToAvoidBottomInset: true,
      body: ListView(
        children: [
          Column(
            children: [
              const LoginImage(),
              const LoginForm(),
              const SizedBox(
                height: 6,
              ),
              const KText(
                text: 'Or sign in',
                color: Colors.black54,
              ),
              const SizedBox(height: 6),
              const LoginWithGoogleAndFacebook(height: 60),
              const SizedBox(height: 12),
              LoginFooter(
                text: 'Sign up',
                onTap: () {
                  context.read<LoginCubit>().idle();
                  context.navigateToRegister();
                },
              ),
            ],
          ),
        ],
      ).disalowIndicator(),
    );
  }
}
