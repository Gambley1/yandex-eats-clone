import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart'
    show CustomIcon, IconType, KText, MenuBloc, kDefaultHorizontalPadding;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;

class DiscountCard extends StatelessWidget {
  const DiscountCard({
    super.key,
    required this.discounts,
  });

  final List<int> discounts;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultHorizontalPadding,
      ),
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
                        const SizedBox(
                          width: 8,
                        ),
                        const KText(
                          text: 'Discount on several items',
                          size: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        KText(
                          text: '${discount.toString()}%',
                          size: 18,
                        )
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
