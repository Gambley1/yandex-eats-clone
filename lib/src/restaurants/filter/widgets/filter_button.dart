import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/home/bloc/main_test_bloc.dart';
import 'package:papa_burger/src/restaurants/filter/filter.dart';
import 'package:shared/shared.dart';

class FilterButton extends StatefulWidget {
  const FilterButton({
    required this.tags,
    super.key,
  });

  final List<Tag> tags;

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _tapAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    )..addListener(() {
        setState(() {});
      });

    _tapAnimation = Tween<double>(begin: 1, end: 0.75).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  Future<void> _playAnimation() async {
    await _controller.forward(from: 1);
    Future.delayed(
      const Duration(milliseconds: 100),
      () => _controller.reverse(from: 0.75),
    );
  }

  void _onTapUp(TapUpDetails details, List<Tag> chosenTags) {
    _playAnimation();
    Future.delayed(const Duration(milliseconds: 200), () {
      context.showCustomModalBottomSheet(
        isScrollControlled: true,
        scrollableSheet: true,
        minChildSize: 0.8,
        showDragHandle: true,
        bottomAppBar: const FilterBottomAppBar(),
        children: [
          FilterView(
            tags: widget.tags,
          ),
        ],
      );
    });
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final chosenTags =
        context.select((MainTestBloc bloc) => bloc.state.chosenTags);
    final chosenTagsCount = chosenTags.length;
    return GestureDetector(
      onTapUp: (details) => _onTapUp(details, chosenTags),
      onTapDown: _onTapDown,
      onTapCancel: _onTapCancel,
      child: Transform.scale(
        scale: _tapAnimation.value,
        child: Column(
          children: [
            Badge(
              alignment: Alignment.topRight,
              backgroundColor: Colors.transparent,
              offset: const Offset(-8, 16),
              isLabelVisible: chosenTagsCount != 0,
              largeSize: 20,
              label: Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.indigo,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 1,
                      color: Colors.black.withOpacity(.4),
                    ),
                  ],
                ),
                child: Text(
                  '$chosenTagsCount',
                  style: context.bodyMedium?.apply(color: AppColors.white),
                ),
              ),
              child: Container(
                height: 60,
                width: 60,
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 24),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius:
                      BorderRadius.circular(AppSpacing.md + AppSpacing.sm),
                ),
                child: Assets.icons.filterIcon.svg(
                  fit: BoxFit.scaleDown,
                  width: 28,
                ),
              ),
            ),
            const SizedBox(height: 2),
            const Text('Filters'),
          ],
        ),
      ),
    );
  }
}
