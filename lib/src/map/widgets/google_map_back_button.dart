import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:yandex_food_delivery_clone/src/map/map.dart';

class GoogleMapBackButton extends StatelessWidget {
  const GoogleMapBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 20,
      top: 20,
      child: SafeArea(
        child: BlocBuilder<MapBloc, MapState>(
          builder: (context, state) {
            final isCameraMoving = state.isCameraMoving;
            return AnimatedOpacity(
              duration: const Duration(milliseconds: 150),
              opacity: isCameraMoving ? 0 : 1,
              child: Row(
                children: [
                  if (context.canPop())
                    DecoratedBox(
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadowEffect.defaultValue,
                        ],
                      ),
                      child: AppIcon.button(
                        icon: Icons.adaptive.arrow_back_sharp,
                        onTap: context.pop,
                        color: AppColors.black,
                      ),
                    ),
                ],
              ).ignorePointer(isMoving: isCameraMoving),
            );
          },
        ),
      ),
    );
  }
}
