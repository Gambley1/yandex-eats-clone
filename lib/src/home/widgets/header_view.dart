import 'package:app_ui/app_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/shared.dart';
import 'package:yandex_food_delivery_clone/src/app/app.dart';
import 'package:yandex_food_delivery_clone/src/map/map.dart';
import 'package:yandex_food_delivery_clone/src/orders/orders.dart';

class HeaderView extends StatelessWidget {
  const HeaderView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);

    return Row(
      children: [
        Builder(
          builder: (context) {
            Widget avatar;
            if (user.photo == null) {
              avatar = Container(
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
                ),
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
                      image: DecorationImage(
                        image: ResizeImage(imageProvider, height: 138),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
                errorWidget: (context, url, error) => const SizedBox.shrink(),
              );
            }
            return Tappable.scaled(
              onTap: () =>
                  Future.delayed(200.ms, Scaffold.of(context).openDrawer),
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
          },
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
            ),
            child: Tappable.faded(
              fadeStrength: FadeStrength.lg,
              onTap: () => context.pushNamed(AppRoutes.googleMap.name),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AddressAndDeliveryText(),
                  BlocBuilder<LocationBloc, LocationState>(
                    builder: (context, state) {
                      final address = state.address.toString();
                      final isLoading = state.status.isLoading;

                      if (isLoading || address.isEmpty) {
                        return ConstrainedBox(
                          constraints: BoxConstraints.tightFor(
                            height: 18,
                            width: context.screenWidth * .5,
                          ),
                          child: ShimmerPlaceholder(
                            borderRadius: BorderRadius.circular(AppSpacing.sm),
                          ),
                        );
                      }

                      return Text(
                        address,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AddressAndDeliveryText extends StatelessWidget {
  const AddressAndDeliveryText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Your address and delivery time',
          maxLines: 1,
          textAlign: TextAlign.center,
          style: context.bodyMedium?.apply(color: AppColors.grey),
        ),
        const AppIcon(
          icon: Icons.arrow_right,
          iconSize: AppSize.lg,
          color: AppColors.grey,
        ),
      ],
    );
  }
}
