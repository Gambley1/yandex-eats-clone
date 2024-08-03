// ignore_for_file: public_member_api_docs

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
      surfaceTintColor: AppColors.white,
      title: Text(
        text,
        style:
            context.headlineSmall?.copyWith(fontWeight: AppFontWeight.semiBold),
      ),
      centerTitle: false,
      leading: AppIcon.button(
        icon: Icons.adaptive.arrow_back_sharp,
        onTap: context.pop,
      ),
      actions: actions,
      elevation: 2,
      backgroundColor: AppColors.white,
      pinned: true,
      floating: true,
      automaticallyImplyLeading: false,
    );
  }
}
