import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:papa_burger/src/restaurant.dart'
    show CustomScaffold, DisalowIndicator, LoginFooter, LoginImage, MyThemeData, NavigatorExtension;

import 'package:papa_burger/src/views/pages/register/components/register_form.dart';
import 'package:papa_burger/src/views/pages/register/state/register_cubit.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: MyThemeData.globalThemeData,
      child: CustomScaffold(
        resizeToAvoidBottomInset: true,
        withReleaseFocus: true,
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
        ).disalowIndicator(),
      ),
    );
  }
}
