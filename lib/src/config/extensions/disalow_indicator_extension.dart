import 'package:flutter/material.dart'
    show NotificationListener, OverscrollIndicatorNotification, Widget;

extension DisalowIndicator on Widget {
  Widget disalowIndicator() =>
      NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return false;
        },
        child: this,
      );
}
