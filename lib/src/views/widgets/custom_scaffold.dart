import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:papa_burger/src/config/utils/my_theme_data.dart';
import 'package:papa_burger/src/restaurant.dart' show WillPopScopeExtension;

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    required this.body,
    super.key,
    this.onWillPop,
    this.withSafeArea = false,
    this.top = true,
    this.bottom = true,
    this.left = true,
    this.right = true,
    this.withReleaseFocus = false,
    this.resizeToAvoidBottomInset = false,
    this.backroundColor,
    this.floatingActionButton,
    this.appBar,
    this.bottomNavigationBar,
    this.drawer,
    this.bottomSheet,
    this.themeData = MyThemeData.globalThemeData,
  });

  final Future<bool> Function()? onWillPop;
  final bool withSafeArea;
  final bool top;
  final bool bottom;
  final bool right;
  final bool left;
  final bool withReleaseFocus;
  final bool resizeToAvoidBottomInset;
  final Widget body;
  final Color? backroundColor;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final AppBar? appBar;
  final Widget? drawer;
  final Widget? bottomSheet;
  final SystemUiOverlayStyle themeData;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    late final scaffoldBackgroundColor = theme.scaffoldBackgroundColor;
    return withReleaseFocus
        ? GestureDetector(
            onTap: () => _releaseFocus(context),
            child: AnnotatedRegion<SystemUiOverlayStyle>(
              value: themeData,
              child: Scaffold(
                resizeToAvoidBottomInset: resizeToAvoidBottomInset,
                backgroundColor: backroundColor ?? scaffoldBackgroundColor,
                body: withSafeArea
                    ? SafeArea(
                        top: top,
                        bottom: bottom,
                        right: right,
                        left: left,
                        child: body,
                      )
                    : body,
                floatingActionButton: floatingActionButton,
                bottomNavigationBar: bottomNavigationBar,
                appBar: appBar,
                drawer: drawer,
                bottomSheet: bottomSheet,
              ).onWillPop(onWillPop),
            ),
          )
        : AnnotatedRegion<SystemUiOverlayStyle>(
            value: themeData,
            child: Scaffold(
              body: withSafeArea
                  ? SafeArea(
                      top: top,
                      bottom: bottom,
                      right: right,
                      left: left,
                      child: body,
                    )
                  : body,
              backgroundColor: backroundColor ?? scaffoldBackgroundColor,
              floatingActionButton: floatingActionButton,
              bottomNavigationBar: bottomNavigationBar,
              appBar: appBar,
              drawer: drawer,
              bottomSheet: bottomSheet,
            ).onWillPop(onWillPop),
          );
  }

  void _releaseFocus(BuildContext context) => FocusScope.of(context).unfocus();
}
