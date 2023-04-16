import 'package:flutter/material.dart'
    show
        BuildContext,
        Colors,
        Column,
        EdgeInsets,
        MainAxisAlignment,
        MainAxisSize,
        Padding,
        SafeArea,
        showGeneralDialog;
import 'package:papa_burger/src/restaurant.dart' show kDefaultHorizontalPadding;
import 'package:flutter_spinkit/flutter_spinkit.dart' show SpinKitCircle;

showEmptyLoadingPage(BuildContext context) {
  return showGeneralDialog(
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) {
      return SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Padding(
              padding: EdgeInsets.only(
                bottom: kDefaultHorizontalPadding + 16,
              ),
              child: SpinKitCircle(
                color: Colors.black,
                size: 38,
              ),
            ),
          ],
        ),
      );
    },
  );
}
