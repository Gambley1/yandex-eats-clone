import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;
import 'package:papa_burger/src/restaurant.dart'
    show
        CustomIcon,
        CustomScaffold,
        DisalowIndicator,
        IconType,
        KText,
        LoginCubit,
        NavigatorExtension,
        showCustomDialog;
import 'package:papa_burger/src/services/network/notification_service.dart';
import 'package:papa_burger/src/views/pages/main_page/components/drawer/components/header_app_bar.dart';
import 'package:papa_burger/src/views/pages/main_page/components/drawer/views/profile/components/user_credentials_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    List<Widget> actions() {
      return [
        CustomIcon(
          icon: FontAwesomeIcons.check,
          type: IconType.iconButton,
          onPressed: () {},
        ),
        CustomIcon(
          icon: FontAwesomeIcons.list,
          type: IconType.iconButton,
          onPressed: () {
            showMenu(
              context: context,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              position: RelativeRect.fromDirectional(
                textDirection: TextDirection.ltr,
                start: 12,
                top: 12,
                end: 0,
                bottom: 0,
              ),
              items: [
                PopupMenuItem<dynamic>(
                  onTap: () {
                    context.read<LoginCubit>().onLogOut();
                    Future.delayed(
                      const Duration(milliseconds: 500),
                      () => context.navigateToLogin(),
                    );
                  },
                  child: GestureDetector(
                    onTap: () => showCustomDialog(
                      context,
                      onTap: () {
                        context.read<LoginCubit>().onLogOut();
                        context.navigateToLogin();
                      },
                      alertText: 'Are you sure to Log out from you Account?',
                      actionText: 'Log out',
                    ),
                    child: const KText(
                      text: 'Logout',
                      size: 18,
                    ),
                  ),
                ),
                PopupMenuItem<dynamic>(
                  onTap: () {
                    NotificationService.showBigTextNotification(
                      title: 'Hello world',
                      body: 'How are you',
                    );
                  },
                  child: GestureDetector(
                    onTap: () => NotificationService.showBigTextNotification(
                      title: 'Hello world',
                      body: 'How are you',
                    ),
                    child: const KText(
                      text: 'Show notifiction',
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ];
    }

    return CustomScaffold(
      withSafeArea: true,
      withReleaseFocus: true,
      body: CustomScrollView(
        slivers: [
          HeaderAppBar(
            text: 'Profile',
            actions: actions(),
          ),
          UserCredentialsView(formKey: formKey),
        ],
      ).disalowIndicator(),
    );
  }
}
