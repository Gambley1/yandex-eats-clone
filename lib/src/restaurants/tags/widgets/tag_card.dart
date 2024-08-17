import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';
import 'package:yandex_food_api/client.dart';
import 'package:yandex_food_delivery_clone/src/restaurants/bloc/restaurants_bloc.dart';

enum _TagScaleType { sm, lg }

class TagCard extends StatelessWidget {
  const TagCard.sm({
    required this.tag,
    required this.selected,
    super.key,
  })  : _scaleType = _TagScaleType.sm,
        onTap = null;

  const TagCard.lg({
    required this.tag,
    required this.selected,
    required this.onTap,
    super.key,
  }) : _scaleType = _TagScaleType.lg;

  final _TagScaleType _scaleType;
  final ValueSetter<Tag>? onTap;
  final Tag tag;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final effectiveImageHeight = switch (_scaleType) {
      _TagScaleType.sm => 60.0,
      _ => 82.0,
    };
    final effectiveFontWeight = switch (_scaleType) {
      _TagScaleType.sm => null,
      _ => AppFontWeight.semiBold,
    };

    return Tappable.scaled(
      onTap: () {
        void onFilterTagSelectedChanged() => context
            .read<RestaurantsBloc>()
            .add(RestaurantsFilterTagChanged(tag));
        Future<void>.delayed(200.ms, () {
          if (onTap != null) return onTap?.call(tag);
          onFilterTagSelectedChanged.call();
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ImageAttachmentThumbnail(
            resizeHeight: 180,
            height: effectiveImageHeight,
            width: effectiveImageHeight,
            borderRadius: BorderRadius.circular(AppSpacing.md),
            imageUrl: tag.imageUrl,
          ),
          const SizedBox(height: AppSpacing.xs),
          if (selected)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md - AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(AppSpacing.md + AppSpacing.sm),
                color: AppColors.deepBlue,
              ),
              child: Text(
                tag.name,
                style: context.bodyMedium
                    ?.copyWith(fontWeight: effectiveFontWeight),
              ),
            )
          else
            Text(
              tag.name,
              style:
                  context.bodyMedium?.copyWith(fontWeight: effectiveFontWeight),
            ),
        ],
      ),
    );
  }
}
