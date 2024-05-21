import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:papa_burger/src/views/widgets/widgets.dart';

class OrderDetailsActionButton extends StatelessWidget {
  const OrderDetailsActionButton({
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
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
            ),
            CustomIcon(
              onPressed: text == 'Hide'
                  ? () {
                      showCustomDialog(
                        context,
                        onTap: onTap,
                        alertText: 'Are you sure to delete your order? '
                            ' You will not be able to see it anymore.',
                        actionText: 'Delete',
                      );
                    }
                  : onTap,
              icon: icon,
              type: IconType.iconButton,
              size: size,
              splashRadius: 60,
              splashColor: Colors.transparent,
              highlightColor: Colors.grey.shade100,
              enableFeedback: true,
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          text,
          style:
              context.bodyMedium?.apply(color: AppColors.grey.withOpacity(.6)),
        ),
      ],
    );
  }
}
