import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart'
    show
        AppInputText,
        CustomIcon,
        IconType,
        KText,
        LocalStorage,
        kDefaultHorizontalPadding;

import '../../../../../../cart/components/choose_payment_modal_bottom_sheet.dart';

class UserCredentialsView extends StatelessWidget {
  const UserCredentialsView({
    super.key,
    required this.formKey,
  });

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    final LocalStorage localStorage = LocalStorage.instance;

    final cookieEmail = localStorage.getEmail;
    final cookieName = localStorage.getUsername;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultHorizontalPadding,
        vertical: kDefaultHorizontalPadding,
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          [
            Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: formKey,
              child: Column(
                children: [
                  AppInputText.withoutBorder(
                    labelText: 'Name',
                    initialValue: cookieName,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Please input your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  AppInputText.withoutBorder(
                    labelText: 'Email',
                    initialValue: cookieEmail,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Please input email';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              horizontalTitleGap: 0,
              onTap: () => showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (context) {
                  return ChoosePaymentModalBottomSheet(allowDelete: true);
                },
              ),
              title: const KText(
                text: 'Payment methods',
              ),
              trailing: const CustomIcon(
                icon: Icons.arrow_forward_ios_sharp,
                type: IconType.simpleIcon,
                size: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
