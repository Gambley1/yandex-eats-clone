import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_fields/form_fields.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:yandex_food_delivery_clone/src/app/app.dart';

class UserCredentialsForm extends StatelessWidget {
  const UserCredentialsForm({
    required this.formKey,
    super.key,
  });

  final GlobalKey<ShadFormState> formKey;

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);

    return Column(
      children: [
        ShadForm(
          key: formKey,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 462),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ShadInputFormField(
                  label: const Text('Email'),
                  placeholder: const Text('Email'),
                  readOnly: true,
                  onPressed: () =>
                      context.pushNamed(AppRoutes.updateEmail.name),
                  initialValue: user.email,
                  prefix: const Padding(
                    padding: EdgeInsets.all(AppSpacing.sm),
                    child: ShadImage.square(
                      size: AppSpacing.lg,
                      LucideIcons.mail,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                ShadInputFormField(
                  id: 'username',
                  label: const Text('Username'),
                  placeholder: const Text('Username'),
                  initialValue: user.name,
                  prefix: const Padding(
                    padding: EdgeInsets.all(AppSpacing.sm),
                    child: ShadImage.square(
                      size: AppSpacing.lg,
                      LucideIcons.user,
                    ),
                  ),
                  validator: (v) {
                    final username = Username.dirty(v);
                    return username.errorMessage;
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
