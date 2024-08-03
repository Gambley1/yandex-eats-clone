import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_fields/form_fields.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:yandex_food_delivery_clone/src/auth/sign_up/sign_up.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<ShadFormState>();
  late ValueNotifier<bool> _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = ValueNotifier(true);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context
        .select((SignUpCubit cubit) => cubit.state.submissionStatus.isLoading);

    return SignUpFormListener(
      child: ShadForm(
        key: _formKey,
        enabled: !isLoading,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 350),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ShadInputFormField(
                id: 'email',
                label: const Text('Email'),
                placeholder: const Text('Enter your email'),
                prefix: const Padding(
                  padding: EdgeInsets.all(AppSpacing.sm),
                  child:
                      ShadImage.square(size: AppSpacing.lg, LucideIcons.mail),
                ),
                validator: (v) {
                  final email = Email.dirty(v);
                  return email.errorMessage;
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              ShadInputFormField(
                id: 'username',
                label: const Text('Username'),
                placeholder: const Text('Enter your username'),
                prefix: const Padding(
                  padding: EdgeInsets.all(AppSpacing.sm),
                  child:
                      ShadImage.square(size: AppSpacing.lg, LucideIcons.user),
                ),
                validator: (v) {
                  final username = Username.dirty(v);
                  return username.errorMessage;
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              ValueListenableBuilder(
                valueListenable: _obscure,
                child: const Padding(
                  padding: EdgeInsets.all(AppSpacing.sm),
                  child:
                      ShadImage.square(size: AppSpacing.lg, LucideIcons.lock),
                ),
                builder: (context, obscure, prefix) {
                  return ShadInputFormField(
                    id: 'password',
                    label: const Text('Password'),
                    placeholder: const Text('Enter your password'),
                    prefix: prefix,
                    obscureText: obscure,
                    suffix: ShadButton.secondary(
                      width: AppSpacing.xlg + AppSpacing.sm,
                      height: AppSpacing.xlg + AppSpacing.sm,
                      padding: EdgeInsets.zero,
                      decoration: const ShadDecoration(
                        secondaryBorder: ShadBorder.none,
                        secondaryFocusedBorder: ShadBorder.none,
                      ),
                      icon: ShadImage.square(
                        size: AppSpacing.lg,
                        obscure ? LucideIcons.eyeOff : LucideIcons.eye,
                      ),
                      onPressed: () {
                        setState(() => _obscure.value = !_obscure.value);
                      },
                    ),
                    validator: (v) {
                      final password = Password.dirty(v);
                      return password.errorMessage;
                    },
                  );
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              BlocBuilder<SignUpCubit, SignUpState>(
                builder: (context, state) {
                  final isLoading = state.submissionStatus.isLoading;
                  return ShadButton(
                    width: double.infinity,
                    text: Text(isLoading ? 'Please wait' : 'Sign up'),
                    enabled: !isLoading,
                    icon: !isLoading
                        ? null
                        : const Padding(
                            padding: EdgeInsets.only(right: AppSpacing.md),
                            child: SizedBox.square(
                              dimension: AppSpacing.lg,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                    onPressed: isLoading
                        ? null
                        : () {
                            if (!(_formKey.currentState?.saveAndValidate() ??
                                false)) {
                              return;
                            }
                            final fields = _formKey.currentState!.value;
                            final username = fields['username'] as String;
                            final email = fields['email'] as String;
                            final password = fields['password'] as String;
                            context.read<SignUpCubit>().onSubmit(
                                  username: username,
                                  email: email,
                                  password: password,
                                );
                          },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
