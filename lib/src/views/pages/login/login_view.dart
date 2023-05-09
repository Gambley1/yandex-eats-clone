import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart'
    show
        CustomScaffold,
        DisalowIndicator,
        KText,
        LoginFooter,
        LoginForm,
        LoginImage,
        LoginWithGoogleAndFacebook,
        MyThemeData;
import 'package:flutter/services.dart' show SystemUiOverlayStyle;

class LoginView extends StatelessWidget {
  const LoginView({
    Key? key,
  }) : super(key: key);

  _buildPage(BuildContext context) => CustomScaffold(
        resizeToAvoidBottomInset: true,
        body: ListView(
          children: [
            Column(
              children: const [
                LoginImage(),
                LoginForm(),
                SizedBox(
                  height: 6,
                ),
                KText(
                  text: 'Or sign in',
                  color: Colors.black54,
                ),
                SizedBox(height: 6),
                LoginWithGoogleAndFacebook(height: 60),
                SizedBox(height: 12),
                LoginFooter(),
              ],
            ),
          ],
        ).disalowIndicator(),
      );

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: MyThemeData.globalThemeData,
      child: Builder(
        builder: (context) {
          return _buildPage(context);
        },
      ),
    );
  }
}
