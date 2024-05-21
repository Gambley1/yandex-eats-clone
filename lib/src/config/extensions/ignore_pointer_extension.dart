import 'package:flutter/material.dart' show IgnorePointer, Widget;

extension IgnorePointerX on Widget {
  Widget ignorePointer({required bool isMoving, bool isMarker = false}) =>
      IgnorePointer(ignoring: isMarker || isMoving, child: this);
}
