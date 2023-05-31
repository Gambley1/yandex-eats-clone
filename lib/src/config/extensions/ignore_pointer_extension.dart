// ignore_for_file: avoid_bool_literals_in_conditional_expressions

import 'package:flutter/material.dart' show IgnorePointer, Widget;

extension IngnorePointerExtension on Widget {
  Widget ignorePointer({required bool isMoving, bool isMarker = false}) =>
      IgnorePointer(
        /// If the boolen variable isMarker is true, that means that we use
        /// ignore pointer for marker to allow user to move camera through it.
        /// Otherwise we just ignoring pointer of any widget of it ancestor
        /// when camera is moving in order to prevent random taps on any widgets
        ignoring: isMarker ? true : isMoving,
        child: this,
      );
}
