import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/views/pages/main/components/categories/components/category_card.dart';
import 'package:papa_burger/src/views/pages/main/components/filter/components/filter_button.dart';
import 'package:papa_burger/src/views/pages/main/state/bloc/main_test_bloc.dart';
import 'package:shared/shared.dart';

class CategoriesSlider extends StatelessWidget {
  const CategoriesSlider({required this.tags, super.key});

  final List<Tag> tags;

  @override
  Widget build(BuildContext context) {
    final chosenTags =
        context.select((MainTestBloc bloc) => bloc.state.chosenTags);
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 120,
        child: ListView.separated(
          key: const PageStorageKey(categoriesKey),
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding:
              const EdgeInsets.symmetric(horizontal: kDefaultHorizontalPadding),
          separatorBuilder: (context, index) => const SizedBox(width: 12),
          scrollDirection: Axis.horizontal,
          itemCount: tags.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return FilterButton(tags: tags);
            } else {
              final categoryIndex = index - 1;
              final tag = tags[categoryIndex];
              final name = tag.name;
              final imageUrl = tag.imageUrl;
              return CategoryCard(
                tags: tags,
                chosenTags: chosenTags,
                categoryIndex: categoryIndex,
                imageUrl: imageUrl,
                tag: tag,
                name: name,
              );
            }
          },
        ),
      ),
    );
  }
}
