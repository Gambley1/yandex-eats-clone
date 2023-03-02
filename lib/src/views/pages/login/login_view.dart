import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:papa_burger/src/restaurant.dart';

class LoginView extends StatelessWidget {
  const LoginView({
    Key? key,
  }) : super(key: key);

  _buildPage(BuildContext context) => GestureDetector(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: ListView(
            children: [
              Column(
                children: [
                  const LoginImage(),
                  const LoginForm(),
                  SizedBox(
                    height: AppDimen.h6,
                  ),
                  const KText(
                    text: 'Or sign in',
                    color: Colors.black54,
                  ),
                  SizedBox(
                    height: AppDimen.h6,
                  ),
                  LoginWithGoogleAndFacebook(
                    height: AppDimen.h60,
                  ),
                  SizedBox(
                    height: AppDimen.h12,
                  ),
                  const LoginFooter(),
                ],
              ),
            ],
          ).disalowIndicator(),
        ),
        onTap: () => _releaseFocus(context),
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

  void _releaseFocus(BuildContext context) => FocusScope.of(context).unfocus();
}
