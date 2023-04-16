import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart'
    show AppDimen, CustomScaffold, DisalowIndicator, KText, LoginFooter, LoginForm, LoginImage, LoginWithGoogleAndFacebook, MyThemeData;
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
          children: [
            const LoginImage(),
            const LoginForm(),
            SizedBox(
              height: AppDimen.h(6),
            ),
            const KText(
              text: 'Or sign in',
              color: Colors.black54,
            ),
            SizedBox(
              height: AppDimen.h(6),
            ),
            LoginWithGoogleAndFacebook(
              height: AppDimen.h(60),
            ),
            SizedBox(
              height: AppDimen.h(12),
            ),
            const LoginFooter(),
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
