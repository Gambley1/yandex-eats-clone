// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart' show IgnorePointer, Widget;

extension IgnorePointerX on Widget {
  Widget ignorePointer({required bool isMoving, bool isMarker = false}) =>
      IgnorePointer(ignoring: isMarker || isMoving, child: this);
}
