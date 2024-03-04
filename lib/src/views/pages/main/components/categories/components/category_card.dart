import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/models/models.dart';
import 'package:papa_burger/src/views/pages/main/state/bloc/main_test_bloc.dart';
import 'package:papa_burger/src/views/widgets/widgets.dart';

class CategoryCard extends StatefulWidget {
  const CategoryCard({
    required this.tags,
    required this.chosenTags,
    required this.categoryIndex,
    required this.imageUrl,
    required this.tag,
    required this.name,
    super.key,
  });

  final List<Tag> tags;
  final List<Tag> chosenTags;
  final int categoryIndex;
  final String imageUrl;
  final Tag tag;
  final String name;

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard>
    with SingleTickerProviderStateMixin {
  late final tagsLength = widget.tags.length;
  late AnimationController _animationController;

  late final List<Animation<double>> _scaleAnimationList =
      List<Animation<double>>.generate(
    tagsLength,
    (index) => Tween<double>(begin: 1, end: 0.75).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    ),
  );

  final List<String> _chosenTags = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _playAnimation() async {
    await _animationController.forward(from: 1);
    Future.delayed(
      const Duration(milliseconds: 100),
      () => _animationController.reverse(from: 0.75),
    );
  }

  void _onTapDown(TapDownDetails details, int index) {
    _animationController.forward();
  }

  Future<void> _onTapUp(TapUpDetails details, int index, Tag tag) async {
    await HapticFeedback.heavyImpact();
    await _playAnimation();
    Future.delayed(const Duration(milliseconds: 200), () {
      _chosenTags.add(tag.name);
      unawaited(
        Future.microtask(
          () => context
              .read<MainTestBloc>()
              .add(MainTestFilterRestaurantsTagChanged(tag)),
        ),
      );
    });
  }

  void _onTapCancel(int index) {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final categoryIndex = widget.categoryIndex;
    final tag = widget.tag;
    final imageUrl = widget.imageUrl;
    final chosenTags = widget.chosenTags;
    final name = widget.name;
    return GestureDetector(
      onTapDown: (details) => _onTapDown(details, categoryIndex),
      onTapUp: (details) => _onTapUp(details, categoryIndex, tag),
      onTapCancel: () => _onTapCancel(categoryIndex),
      child: ScaleTransition(
        scale: _scaleAnimationList[categoryIndex],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CachedImage(
              height: 90,
              width: 80,
              shimmerHeight: 60,
              shimmerWidth: 60,
              imageType: CacheImageType.smallImage,
              imageUrl: imageUrl,
            ),
            if (chosenTags.contains(tag))
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultHorizontalPadding - 4,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                  color: kPrimaryBackgroundColor,
                ),
                child: KText(text: name, size: 14, color: Colors.white),
              )
            else
              KText(text: name, size: 14),
          ],
        ),
      ),
    );
  }
}
