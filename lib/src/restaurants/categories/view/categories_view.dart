import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/home/bloc/main_test_bloc.dart';
import 'package:papa_burger/src/restaurants/categories/widgets/category_card.dart';
import 'package:papa_burger/src/restaurants/filter/widgets/filter_button.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
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
