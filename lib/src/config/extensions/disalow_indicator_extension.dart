import 'package:flutter/material.dart'
    show Widget, NotificationListener, OverscrollIndicatorNotification;

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
