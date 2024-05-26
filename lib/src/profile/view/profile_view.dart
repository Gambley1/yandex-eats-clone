import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/login/cubit/login_cubit.dart';
import 'package:papa_burger/src/profile/widgets/user_credentials_view.dart';
import 'package:papa_burger/src/services/network/notification_service.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<ShadFormState>();

    List<Widget> actions() {
      return [
        AppIcon(
          icon: LucideIcons.check,
          type: IconType.button,
          onPressed: () {},
        ),
        AppIcon(
          icon: LucideIcons.list,
          type: IconType.button,
          onPressed: () {
            showMenu(
              context: context,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              position: RelativeRect.fromDirectional(
                textDirection: TextDirection.ltr,
                start: AppSpacing.md,
                top: AppSpacing.md,
                end: 0,
                bottom: 0,
              ),
              items: [
                PopupMenuItem<dynamic>(
                  onTap: () {
                    context.read<LoginCubit>().onLogOut();
                    Future.delayed(
                      const Duration(milliseconds: 500),
                      () => context.pushReplacementNamed(AppRoutes.login.name),
                    );
                  },
                  child: GestureDetector(
                    onTap: () => context.showCustomDialog(
                      onTap: () {
                        context.read<LoginCubit>().onLogOut();
                        context.pushReplacementNamed(AppRoutes.login.name);
                      },
                      alertText: 'Are you sure to Log out from you Account?',
                      actionText: 'Log out',
                    ),
                    child: Text(
                      'Logout',
                      style: context.bodyLarge,
                    ),
                  ),
                ),
                PopupMenuItem<dynamic>(
                  onTap: () {
                    NotificationService.showOngoingNotification(
                      title: 'Hello ',
                      body: 'This is an ongoing notification!',
                    );
                  },
                  child: GestureDetector(
                    onTap: NotificationService.cancelAllNotifications,
                    child: const Text(
                      'Show notification',
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ];
    }

    return AppScaffold(
      releaseFocus: true,
      body: CustomScrollView(
        slivers: [
          HeaderAppBar(
            text: 'Profile',
            actions: actions(),
          ),
          UserCredentialsView(formKey: formKey),
        ],
      ),
    );
  }
}
