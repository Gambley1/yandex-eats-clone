import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// {@template network_error}
/// A network error alert.
/// {@endtemplate}
class NetworkError extends StatelessWidget {
  /// {@macro network_error}
  const NetworkError({super.key, this.onRetry});

  /// An optional callback which is invoked when the retry button is pressed.
  final VoidCallback? onRetry;

  /// Route constructor to display the widget inside a [Scaffold].
  static Route<void> route({VoidCallback? onRetry}) {
    return PageRouteBuilder<void>(
      pageBuilder: (_, __, ___) => Scaffold(
        body: Center(
          child: NetworkError(onRetry: onRetry),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: AppSpacing.xlg),
        Icon(
          Icons.error_outline,
          size: 80,
          color: context.adaptiveColor,
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'A network error has occurred. Check your connection and try again.',
          style: theme.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.lg),
        Center(
          child: ShadButton(
            onPressed: onRetry,
            icon: const Padding(
              padding: EdgeInsets.only(right: AppSpacing.md),
              child: ShadImage.square(
                size: AppSize.xlg,
                Icons.refresh,
              ),
            ),
            text: const Text('Try Again'),
          ),
        ),
        const SizedBox(height: AppSpacing.xlg),
      ],
    );
  }
}
