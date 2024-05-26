import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:papa_burger/src/config/config.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    super.key,
    this.withNavigation = true,
    this.enabled = true,
    this.labelText = searchFoodLabel,
    this.onChanged,
    this.controller,
  });

  final bool withNavigation;
  final bool enabled;
  final String labelText;
  final TextEditingController? controller;
  final ValueSetter<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: withNavigation
          ? () => context.pushNamed(AppRoutes.search.name)
          : () {},
      child: ShadInput(
        enabled: enabled,
        controller: controller,
        placeholder: Text(labelText),
        onChanged: onChanged,
        decoration: const ShadDecoration(
          border: ShadBorder(
            color: AppColors.grey,
          ),
        ),
        prefix: const Padding(
          padding: EdgeInsets.only(right: AppSpacing.sm),
          child: Icon(LucideIcons.search, color: AppColors.grey),
        ),
      ),
    );
  }
}
