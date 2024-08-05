import 'dart:math';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class MenuAppBarBackgroundImage extends StatelessWidget {
  const MenuAppBarBackgroundImage({
    required this.placeId,
    required this.imageUrl,
    super.key,
  });

  final String placeId;
  final String imageUrl;

  Color _getRandomColor() {
    final colorList = [
      Colors.brown.withOpacity(.9),
      Colors.black.withOpacity(.9),
      Colors.cyan.withOpacity(.8),
      Colors.greenAccent.withOpacity(.8),
      Colors.indigo.withOpacity(.9),
    ];

    final placeId = this.placeId.replaceAll(RegExp(r'[^\d]'), '');
    final index = int.tryParse(placeId) ?? 1;
    final random = Random(index);
    return colorList[random.nextInt(colorList.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ImageAttachmentThumbnail.network(imageUrl: imageUrl),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.transparent,
                  _getRandomColor(),
                ],
                stops: const [0.1, 1],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
