import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:papa_burger/src/config/extensions/navigator_extension.dart';
import 'package:papa_burger/src/restaurant.dart'
    show
        CustomScaffold,
        DisalowIndicator,
        KText,
        LoginCubit,
        LoginFooter,
        LoginForm,
        LoginImage,
        LoginWithGoogleAndFacebook,
        MyThemeData;

class LoginView extends StatelessWidget {
  const LoginView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: MyThemeData.globalThemeData,
      child: CustomScaffold(
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
      ),
    );
  }
}
