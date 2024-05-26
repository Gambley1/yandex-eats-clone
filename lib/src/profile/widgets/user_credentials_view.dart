import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:form_fields/form_fields.dart';
import 'package:papa_burger/src/cart/widgets/choose_payment_modal_bottom_sheet.dart';
import 'package:papa_burger/src/services/storage/storage.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class UserCredentialsView extends StatelessWidget {
  const UserCredentialsView({
    required this.formKey,
    super.key,
  });

  final GlobalKey<ShadFormState> formKey;

  @override
  Widget build(BuildContext context) {
    final cookieUser = LocalStorage().getUser;
    late final email = cookieUser?.email;
    late final username = cookieUser?.username;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          [
            ShadForm(
              key: formKey,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 350),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ShadInputFormField(
                      id: 'email',
                      label: const Text('Email'),
                      placeholder: const Text('Email'),
                      initialValue: email,
                      prefix: const Padding(
                        padding: EdgeInsets.all(AppSpacing.sm),
                        child: ShadImage.square(
                          size: AppSpacing.lg,
                          LucideIcons.mail,
                        ),
                      ),
                      validator: (v) {
                        final email = Email.dirty(v);
                        return email.errorMessage;
                      },
                    ),
                    ShadInputFormField(
                      id: 'username',
                      label: const Text('Username'),
                      placeholder: const Text('Username'),
                      initialValue: username,
                      prefix: const Padding(
                        padding: EdgeInsets.all(AppSpacing.sm),
                        child: ShadImage.square(
                          size: AppSpacing.lg,
                          LucideIcons.user,
                        ),
                      ),
                      validator: (v) {
                        final password = Username.dirty(v);
                        return password.errorMessage;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () => showModalBottomSheet<void>(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (context) {
                  return ChoosePaymentModalBottomSheet(allowDelete: true);
                },
              ),
              leading: const Icon(LucideIcons.creditCard),
              title: const Text('Payment methods'),
              trailing: AppIcon(
                icon: Icons.adaptive.arrow_forward_sharp,
                size: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
