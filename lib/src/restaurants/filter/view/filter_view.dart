import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:flexible_wrap/flexible_wrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:yandex_food_api/client.dart';
import 'package:yandex_food_delivery_clone/src/restaurants/filter/filter.dart';
import 'package:yandex_food_delivery_clone/src/restaurants/restaurants.dart';
import 'package:yandex_food_delivery_clone/src/restaurants/tags/tags.dart';

class FilterView extends StatefulWidget {
  const FilterView({
    required this.scrollController,
    super.key,
  });

  final ScrollController scrollController;

  @override
  State<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  final _chosenTags = <Tag>[];
  bool _applyFilter = false;

  @override
  void initState() {
    _chosenTags.addAll(context.read<RestaurantsBloc>().state.chosenTags);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      bottomNavigationBar: AppBottomBar(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.md,
              horizontal: AppSpacing.lg,
            ),
            child: ShadButton(
              backgroundColor: AppColors.deepBlue,
              width: double.infinity,
              onPressed: () {
                context.pop();
                if (!_applyFilter) return;
                context
                    .read<RestaurantsBloc>()
                    .add(RestaurantsFilterTagsChanged(_chosenTags));
              },
              size: ShadButtonSize.lg,
              text: const Text('Apply'),
            ),
          ),
        ],
      ),
      body: AppConstrainedScrollView(
        controller: widget.scrollController,
        child: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.xlg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FilterSection.top(
                title: 'Special',
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: AppSpacing.lg,
                      right: AppSpacing.lg,
                      top: AppSpacing.md,
                    ),
                    child: Tappable.scaled(
                      backgroundColor: AppColors.brightGrey,
                      borderRadius: AppSpacing.md,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.xs,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.favorite,
                              color: AppColors.red,
                            ),
                            SizedBox(width: AppSpacing.xs),
                            Text('Favourite'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xlg),
              Expanded(
                child: FilterSection.bottom(
                  title: 'Cuisines and dishes',
                  children: [
                    BlocBuilder<RestaurantsBloc, RestaurantsState>(
                      builder: (context, state) {
                        final tags = state.tags;
                        final chosenTags = state.chosenTags;

                        return FlexibleWrap(
                          spacing: AppSpacing.md,
                          isOneRowExpanded: true,
                          children: tags.map((tag) {
                            return TagCard.lg(
                              tag: tag,
                              selected: _chosenTags.contains(tag),
                              onTap: (tag) {
                                setState(() {
                                  _chosenTags.contains(tag)
                                      ? _chosenTags.remove(tag)
                                      : _chosenTags.add(tag);
                                  _applyFilter = !const ListEquality<Tag>()
                                      .equals(_chosenTags, chosenTags);
                                });
                              },
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
