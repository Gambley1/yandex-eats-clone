import 'package:flutter/material.dart';
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/services/storage/storage.dart';
import 'package:papa_burger/src/views/pages/cart/components/choose_payment_modal_bottom_sheet.dart';
import 'package:papa_burger/src/views/widgets/widgets.dart';

class UserCredentialsView extends StatelessWidget {
  const UserCredentialsView({
    required this.formKey,
    super.key,
  });

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    final cookieUser = LocalStorage().getUser;
    late final email = cookieUser!.email;
    late final name = cookieUser!.username;

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
                  AppTextField(
                    border: InputBorder.none,
                    labelText: 'Name',
                    initialValue: name,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Please input your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    border: InputBorder.none,
                    labelText: 'Email',
                    initialValue: email,
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
              onTap: () => showModalBottomSheet<dynamic>(
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
