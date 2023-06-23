import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;
import 'package:papa_burger/src/restaurant.dart'
    show CustomIcon, IconType, KText, NavigatorExtension;

class HeaderAppBar extends StatelessWidget {
  const HeaderAppBar({
    required this.text,
    this.actions,
    super.key,
  });

  final String text;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      forceElevated: true,
      title: KText(
        text: text,
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
      actions: actions,
      elevation: 2,
      backgroundColor: Colors.white,
      pinned: true,
      floating: true,
      automaticallyImplyLeading: false,
    );
  }
}
