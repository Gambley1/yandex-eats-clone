import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

/// Renders a widget containing a progress indicator that calls
/// [onPresented] when the item becomes visible.
class RestaurantsLoaderItem extends StatefulWidget {
  const RestaurantsLoaderItem({super.key, this.onPresented});

  /// A callback performed when the widget is presented.
  final VoidCallback? onPresented;

  @override
  State<RestaurantsLoaderItem> createState() => _FeedLoaderItemState();
}

class _FeedLoaderItemState extends State<RestaurantsLoaderItem> {
  @override
  void initState() {
    super.initState();
    Future.delayed(350.ms, () => widget.onPresented?.call());
  }

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Center(
        child: AppCircularProgressIndicator(),
      ),
    );
  }
}
