import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class OrderActionButton extends StatelessWidget {
  const OrderActionButton({
    required this.text,
    required this.icon,
    required this.onTap,
    this.deleteOrder,
    this.size = 26,
    super.key,
  });

  final String text;
  final IconData icon;
  final double size;
  final void Function() onTap;
  final Future<String> Function()? deleteOrder;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: const BoxDecoration(
                color: AppColors.brightGrey,
                shape: BoxShape.circle,
              ),
            ),
            AppIcon.button(
              onTap: text == 'Hide'
                  ? () {
                      context.confirmAction(
                        fn: onTap,
                        title: 'Delete order',
                        content: 'Are you sure you want to delete this order?',
                        noText: 'No, keep it',
                        yesText: 'Yes, delete',
                      );
                    }
                  : onTap,
              icon: icon,
              iconSize: size,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          text,
          style: context.bodyMedium?.apply(color: AppColors.grey),
        ),
      ],
    );
  }
}
