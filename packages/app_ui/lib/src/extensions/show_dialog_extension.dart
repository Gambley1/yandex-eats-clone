// ignore_for_file: public_member_api_docs

import 'package:app_ui/app_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension ShowDialogExtension on BuildContext {
  Future<bool?> showInfoDialog({
    required String title,
    String? content,
    String? actionText,
  }) =>
      showAdaptiveDialog(
        title: title,
        content: content,
        actions: [
          DialogButton(text: actionText ?? 'Ok', onPressed: pop),
        ],
      );

  /// Shows adaptive dialog with provided `title`, `content` and `actions`
  /// (if provided). If `barrierDismissible` is `true` (default), dialog can't
  /// be dismissed by tapping outside of the dialog.
  Future<T?> showAdaptiveDialog<T>({
    String? content,
    String? title,
    List<Widget> actions = const [],
    bool barrierDismissible = true,
    Widget Function(BuildContext)? builder,
    TextStyle? titleTextStyle,
  }) =>
      showDialog<T>(
        context: this,
        barrierDismissible: barrierDismissible,
        builder: builder ??
            (context) {
              return AlertDialog.adaptive(
                actionsAlignment: MainAxisAlignment.end,
                title: Text(title!),
                titleTextStyle: titleTextStyle,
                content: content == null ? null : Text(content),
                actions: actions,
              );
            },
      );

  /// Shows the confirmation dialog and upon confirmation executes provided
  /// [fn].
  Future<void> confirmAction({
    required void Function() fn,
    required String title,
    required String noText,
    required String yesText,
    String? content,
    TextStyle? yesTextStyle,
    TextStyle? noTextStyle,
    void Function(BuildContext context)? noAction,
  }) async {
    final isConfirmed = await showConfirmationDialog(
      title: title,
      content: content,
      noText: noText,
      yesText: yesText,
      yesTextStyle: yesTextStyle,
      noTextStyle: noTextStyle,
      noAction: noAction,
    );
    if (isConfirmed == null || !isConfirmed) return;
    fn.call();
  }

  /// Shows a dialog that alerts user that they are about to do distractive
  /// action.
  Future<bool?> showConfirmationDialog({
    required String title,
    required String noText,
    required String yesText,
    String? content,
    void Function(BuildContext context)? noAction,
    void Function(BuildContext context)? yesAction,
    TextStyle? noTextStyle,
    TextStyle? yesTextStyle,
    bool distractiveAction = true,
    bool barrierDismissible = true,
  }) =>
      showAdaptiveDialog<bool?>(
        title: title,
        content: content,
        barrierDismissible: barrierDismissible,
        titleTextStyle: headlineSmall,
        actions: [
          DialogButton(
            isDefaultAction: true,
            onPressed: () => noAction == null
                ? (canPop() ? pop(false) : null)
                : noAction.call(this),
            text: noText,
            textStyle: noTextStyle ?? labelLarge?.apply(color: adaptiveColor),
          ),
          DialogButton(
            isDestructiveAction: true,
            onPressed: () => yesAction == null
                ? (canPop() ? pop(true) : null)
                : yesAction.call(this),
            text: yesText,
            textStyle: yesTextStyle ?? labelLarge?.apply(color: AppColors.red),
          ),
        ],
      );

  /// Shows bottom modal.
  Future<T?> showBottomModal<T>({
    Widget Function(BuildContext context)? builder,
    String? title,
    Color? titleColor,
    Widget? content,
    Color? backgroundColor,
    Color? barrierColor,
    ShapeBorder? border,
    bool rounded = true,
    bool isDismissible = true,
    bool isScrollControlled = false,
    bool enableDrag = true,
    bool useSafeArea = false,
    bool showDragHandle = false,
  }) =>
      showModalBottomSheet(
        context: this,
        shape: border ??
            (!rounded
                ? null
                : const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  )),
        showDragHandle: showDragHandle,
        backgroundColor: backgroundColor,
        barrierColor: barrierColor,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        useSafeArea: useSafeArea,
        clipBehavior: Clip.hardEdge,
        isScrollControlled: isScrollControlled,
        useRootNavigator: true,
        builder: builder ??
            (context) {
              return Material(
                type: MaterialType.transparency,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (title != null) ...[
                      Text(
                        title,
                        style: context.titleLarge?.copyWith(color: titleColor),
                      ),
                      const Divider(),
                    ],
                    content!,
                  ],
                ),
              );
            },
      );

  /// Opens the modal bottom sheet for a comments page builder.
  Future<void> showScrollableModal({
    required Widget Function(
      ScrollController scrollController,
      DraggableScrollableController draggableScrollController,
    ) pageBuilder,
    bool isDismissible = true,
    double initialChildSize = .7,
    bool showFullSized = false,
    bool showDragHandle = false,
    double minChildSize = .4,
    double maxChildSize = 1.0,
    bool withSnapSizes = true,
    bool snap = true,
    List<double>? snapSizes,
  }) =>
      showBottomModal<void>(
        isScrollControlled: true,
        showDragHandle: showDragHandle,
        isDismissible: isDismissible,
        builder: (context) {
          final controller = DraggableScrollableController();
          return DraggableScrollableSheet(
            controller: controller,
            expand: false,
            snap: snap,
            snapSizes: withSnapSizes ? snapSizes ?? const [.6, 1] : null,
            initialChildSize: showFullSized ? 1.0 : initialChildSize,
            minChildSize: minChildSize,
            maxChildSize: maxChildSize,
            builder: (context, scrollController) =>
                pageBuilder.call(scrollController, controller),
          );
        },
      );
}

/// {@template dialog_button}
/// A custom dialog button widget.
/// {@endtemplate}
class DialogButton extends StatelessWidget {
  /// {@macro dialog_button}
  const DialogButton({
    this.text,
    this.isDefaultAction = false,
    this.isDestructiveAction = false,
    super.key,
    this.onPressed,
    this.style,
    this.textStyle,
  });

  /// Function to be called when the button is pressed.
  final void Function()? onPressed;

  /// The text to be displayed on the button.
  final String? text;

  /// The style of the button.
  final ButtonStyle? style;

  /// The style of the text on the button.
  final TextStyle? textStyle;

  /// The flag to indicate if the button is the default action in a dialog.
  final bool isDefaultAction;

  /// The flag to indicate if the button is the destructive action in a dialog.
  final bool isDestructiveAction;

  @override
  Widget build(BuildContext context) {
    final text = _Text(
      text: this.text!,
      style: textStyle,
    );
    final effectiveChild = text;

    final platform = context.theme.platform;
    final isIOS = platform == TargetPlatform.iOS;

    return Builder(
      builder: (_) {
        if (isIOS) {
          return CupertinoDialogAction(
            onPressed: onPressed,
            isDefaultAction: isDefaultAction,
            isDestructiveAction: isDestructiveAction,
            child: effectiveChild,
          );
        } else {
          return TextButton(
            onPressed: onPressed,
            child: effectiveChild,
          );
        }
      },
    );
  }
}

class _Text extends StatelessWidget {
  const _Text({required this.text, this.style});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: style,
      overflow: TextOverflow.ellipsis,
      child: Text(text),
    );
  }
}
