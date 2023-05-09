import 'package:flutter/material.dart' show Widget, WillPopScope;

extension WillPopScopeExtension on Widget {
  Widget onWillPop(Future<bool> Function()? onWillPop) =>
      WillPopScope(onWillPop: onWillPop, child: this);
}
