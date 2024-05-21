import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/views/widgets/widgets.dart';

Future<bool?> showCustomDialog(
  BuildContext context, {
  required void Function() onTap,
  required String alertText,
  required String actionText,
  String cancelText = 'Cancel',
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Text(alertText),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.lg + AppSpacing.xxs),
        ),
        contentPadding: const EdgeInsets.all(AppSpacing.md),
        actions: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => context.pop(withHapticFeedback: true),
                  child: CustomButtonInShowDialog(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.lg + AppSpacing.xxs),
                    padding: const EdgeInsets.all(AppSpacing.md),
                    colorDecoration: Colors.grey.shade200,
                    text: cancelText,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: GestureDetector(
                  onTap: onTap,
                  child: CustomButtonInShowDialog(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.lg + AppSpacing.xxs),
                    padding: const EdgeInsets.all(AppSpacing.md),
                    colorDecoration: AppColors.indigo,
                    text: actionText,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}
