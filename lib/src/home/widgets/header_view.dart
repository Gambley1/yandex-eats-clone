import 'package:app_ui/app_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:go_router/go_router.dart';
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/home/bloc/badge_notifier.dart';
import 'package:papa_burger/src/home/bloc/location_bloc.dart';

class HeaderView extends StatefulWidget {
  const HeaderView({super.key});

  @override
  State<HeaderView> createState() => _HeaderViewState();
}

class _HeaderViewState extends State<HeaderView>
    with SingleTickerProviderStateMixin {
  final BadgeNotifier _badgeNotifier = BadgeNotifier();

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  bool isTapped = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 100,
      ),
    )..addListener(() {
        setState(() {});
      });
    _scaleAnimation = Tween<double>(begin: 1, end: 0.75).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  ValueListenableBuilder<String> _buildAddressName(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: LocationNotifier(),
      builder: (context, address, _) {
        return Text(
          address,
          maxLines: 1,
          textAlign: TextAlign.center,
        );
      },
    );
  }

  Widget _buildAddressAndDeliveryText() => Row(
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
            size: 24,
            color: Colors.grey,
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CachedNetworkImage(
          imageUrl: headerPhoto,
          imageBuilder: (context, imageProvider) {
            return GestureDetector(
              onTapDown: (TapDownDetails details) {
                setState(() {
                  isTapped = true;
                });
                _animationController.forward();
              },
              onTapUp: (_) {
                setState(() {
                  isTapped = false;
                });
                _animationController.reverse();
                HapticFeedback.heavyImpact();
                Scaffold.of(context).openDrawer();
              },
              onTapCancel: () {
                setState(() {
                  isTapped = false;
                });
                _animationController.reverse();
              },
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: ValueListenableBuilder<bool>(
                  valueListenable: _badgeNotifier,
                  builder: (context, hasPendingOrders, _) {
                    return Badge(
                      alignment: Alignment.topRight,
                      backgroundColor: Colors.transparent,
                      offset: const Offset(-2, 0),
                      isLabelVisible: hasPendingOrders,
                      label: Container(
                        height: 20,
                        width: 20,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          color: Colors.orange.shade900,
                          shape: BoxShape.circle,
                        ),
                      ),
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.grey.withOpacity(.4),
                            ),
                          ],
                          border: Border.all(width: 2, color: Colors.white),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
          placeholder: (context, url) => const ShimmerLoading(
            width: 50,
            height: 50,
            shape: BoxShape.circle,
          ),
          errorWidget: (context, url, error) => const SizedBox.shrink(),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
            ),
            child: InkWell(
              onTap: () => context.pushNamed(AppRoutes.googleMap.name),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildAddressAndDeliveryText(),
                  _buildAddressName(context),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
