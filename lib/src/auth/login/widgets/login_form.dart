import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_fields/form_fields.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:yandex_food_delivery_clone/src/auth/login/login.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<ShadFormState>();
  late ValueNotifier<bool> _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = ValueNotifier(true);
  }

  @override
  void dispose() {
    _obscure.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context
        .select((LoginCubit cubit) => cubit.state.submissionStatus.isLoading);

    return LoginFormListener(
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
              BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) {
                  final isLoading = state.submissionStatus.isLoading;
                  if (!isLoading) {
                    return ShadButton(
                      width: double.infinity,
                      text: const Text('Login'),
                      onPressed: () {
                        if (!(_formKey.currentState?.saveAndValidate() ??
                            false)) {
                          return;
                        }
                        final fields = _formKey.currentState!.value;
                        final email = fields['email'] as String;
                        final password = fields['password'] as String;
                        context
                            .read<LoginCubit>()
                            .onSubmit(email: email, password: password);
                      },
                    );
                  }
                  return const ShadButton(
                    width: double.infinity,
                    text: Text('Please wait'),
                    enabled: false,
                    icon: Padding(
                      padding: EdgeInsets.only(right: AppSpacing.md),
                      child: SizedBox.square(
                        dimension: AppSpacing.lg,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
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
