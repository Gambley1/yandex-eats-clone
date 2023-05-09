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
import 'package:papa_burger/src/views/pages/main_page/components/drawer/views/profile/components/user_credentials_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    buildHeader() => SliverAppBar(
          forceElevated: true,
          title: const KText(
            text: 'Profile',
            size: 26,
            fontWeight: FontWeight.bold,
          ),
          leading: CustomIcon(
            icon: FontAwesomeIcons.arrowLeft,
            type: IconType.iconButton,
            onPressed: () {
              context.pop();
            },
          ),
          actions: [
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
                    PopupMenuItem(
                      onTap: () {
                        context.read<LoginCubit>().onLogOut();
                        Future.delayed(const Duration(milliseconds: 500)).then(
                          (_) => context.navigateToLogin(),
                        );
                      },
                      child: GestureDetector(
                        onTap: () => showCustomDialog(
                          context,
                          onTap: () {
                            context.read<LoginCubit>().onLogOut();
                            context.navigateToLogin();
                            return Future.value(true);
                          },
                          alertText:
                              'Are you sure to Log out from you Account?',
                          actionText: 'Log out',
                        ),
                        child: const KText(
                          text: 'Logout',
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
          elevation: 0.5,
          backgroundColor: Colors.white,
          pinned: true,
          floating: true,
          snap: false,
          automaticallyImplyLeading: false,
        );

    return CustomScaffold(
      withSafeArea: true,
      withReleaseFocus: true,
      body: CustomScrollView(
        slivers: [
          buildHeader(),
          UserCredentialsView(formKey: formKey),
        ],
      ).disalowIndicator(),
    );
  }
}
