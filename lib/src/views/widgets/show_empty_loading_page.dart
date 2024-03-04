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
import 'package:flutter_spinkit/flutter_spinkit.dart' show SpinKitCircle;
import 'package:papa_burger/src/config/config.dart';

Future<Object?> showEmptyLoadingPage(BuildContext context) {
  return showGeneralDialog(
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) {
      return const SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: kDefaultHorizontalPadding + 16),
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
