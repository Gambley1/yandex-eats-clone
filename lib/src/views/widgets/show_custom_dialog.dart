import 'package:flutter/material.dart'
    show
        AlertDialog,
        BorderRadius,
        BuildContext,
        Colors,
        EdgeInsets,
        Expanded,
        GestureDetector,
        RoundedRectangleBorder,
        Row,
        SizedBox,
        showDialog;
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/views/widgets/widgets.dart';

Future<dynamic> showCustomDialog(
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
        content: KText(
          text: alertText,
          maxLines: 3,
          size: 18,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        actions: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => context.pop(withHaptickFeedback: true),
                  child: CustomButtonInShowDialog(
                    borderRadius: BorderRadius.circular(18),
                    padding: const EdgeInsets.all(10),
                    colorDecoration: Colors.grey.shade200,
                    size: 18,
                    text: cancelText,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: onTap,
                  child: CustomButtonInShowDialog(
                    borderRadius: BorderRadius.circular(18),
                    padding: const EdgeInsets.all(10),
                    colorDecoration: kPrimaryBackgroundColor,
                    size: 18,
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
