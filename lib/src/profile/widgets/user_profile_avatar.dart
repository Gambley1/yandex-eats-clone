import 'package:app_ui/app_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';
import 'package:yandex_food_delivery_clone/src/app/app.dart';
import 'package:yandex_food_delivery_clone/src/orders/orders.dart';

class UserProfileAvatar extends StatelessWidget {
  const UserProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);

    final avatar = () {
      Widget avatar;
      Widget container({Widget? child, DecorationImage? image}) {
        return Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                spreadRadius: 2,
                blurRadius: 10,
                color: AppColors.grey.withOpacity(.4),
              ),
            ],
            border: Border.all(width: 2, color: AppColors.white),
            shape: BoxShape.circle,
            image: image,
          ),
          child: child,
        );
      }

      if (user.photo == null) {
        avatar = container(
          child: CircleAvatar(
            radius: AppSpacing.md,
            backgroundColor: AppColors.white,
            foregroundImage: ResizeImage(
              Assets.images.profilePhoto.provider(),
              height: 138,
            ),
          ),
        );
      } else {
        avatar = CachedNetworkImage(
          imageUrl: user.photo!,
          imageBuilder: (_, imageProvider) {
            return container(
              image: DecorationImage(
                image: ResizeImage(imageProvider, height: 138),
                fit: BoxFit.cover,
              ),
            );
          },
          placeholder: (_, __) => const ShimmerPlaceholder.circular(radius: 25),
          errorWidget: (_, __, ___) => const SizedBox.shrink(),
        );
      }
      return avatar;
    }();

    return Tappable.scaled(
      onTap: () => Future.delayed(200.ms, Scaffold.of(context).openDrawer),
      child: BlocBuilder<OrdersBloc, OrdersState>(
        builder: (context, state) {
          return Badge(
            alignment: Alignment.topRight,
            backgroundColor: AppColors.transparent,
            offset: const Offset(-2, 0),
            isLabelVisible: state.hasPendingOrders,
            label: Container(
              height: 20,
              width: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.white),
                color: AppColors.orangeAccent,
                shape: BoxShape.circle,
              ),
            ),
            child: avatar,
          );
        },
      ),
    );
  }
}
