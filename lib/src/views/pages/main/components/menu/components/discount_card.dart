import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/models/models.dart';
import 'package:papa_burger/src/views/widgets/widgets.dart';

class DiscountCard extends StatelessWidget {
  const DiscountCard({
    required this.discounts,
    super.key,
  });

  final List<int> discounts;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding:
          const EdgeInsets.symmetric(horizontal: kDefaultHorizontalPadding),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: discounts.map(
            (discount) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultHorizontalPadding - 6,
                    ),
                    margin: const EdgeInsets.symmetric(
                      vertical: kDefaultHorizontalPadding - 6,
                    ),
                    height: MenuBloc.discountHeight,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.shade200,
                          Colors.blue.shade300,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(
                        28,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              colors: [
                                Colors.lightBlue.shade400,
                                Colors.lightBlue.shade100,
                              ],
                            ),
                          ),
                          child: const CustomIcon(
                            icon: FontAwesomeIcons.percent,
                            type: IconType.simpleIcon,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        const Text('Discount on several items'),
                        const SizedBox(width: AppSpacing.sm),
                        Text('$discount%', style: context.bodyLarge),
                      ],
                    ),
                  ),
                ],
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
