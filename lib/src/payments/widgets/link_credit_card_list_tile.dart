import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:yandex_food_delivery_clone/src/payments/payments.dart';

class LinkCreditCardListTile extends StatelessWidget {
  const LinkCreditCardListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () => context.showBottomModal<void>(
            isScrollControlled: true,
            builder: (_) {
              return const AddCreditCardModalView();
            },
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
          ),
          title: const Text('Link a new credit card'),
          trailing: AppIcon(
            icon: Icons.adaptive.arrow_forward_sharp,
            iconSize: AppSize.xs,
          ),
          leading: const AppIcon(
            icon: LucideIcons.creditCard,
            iconSize: AppSize.md,
          ),
        ),
      ],
    );
  }
}
