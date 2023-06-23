import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart'
    show
        CacheImageType,
        CachedImage,
        KText,
        Tag,
        kDefaultHorizontalPadding,
        kDefaultVerticalPadding;

class FilterView extends StatelessWidget {
  const FilterView({required this.tags, super.key});

  final List<Tag> tags;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultHorizontalPadding,
        vertical: kDefaultVerticalPadding,
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const KText(
                text: 'Cuisines and dishes',
                size: 24,
                fontWeight: FontWeight.w600,
              ),
              Wrap(
                spacing: 10,
                children: tags.map((e) {
                  final imageUrl = e.imageUrl;
                  final name = e.name;
                  return Column(
                    children: [
                      CachedImage(
                        height: 80,
                        width: 80,
                        imageUrl: imageUrl,
                        imageType: CacheImageType.smallImage,
                      ),
                      KText(
                        text: name,
                        size: 14,
                      ),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
