// ignore_for_file: lines_longer_than_80_chars

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:papa_burger/src/home/bloc/main_test_bloc.dart';

class ResetFiltersButton extends StatelessWidget {
  const ResetFiltersButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppSpacing.md + AppSpacing.sm),
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: () {
        context.read<MainTestBloc>().add(const MainTestTagsFiltersClear());
      },
      child: Ink(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xxlg,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.md + AppSpacing.sm),
          color: Colors.grey.shade300,
        ),
        child: Align(
          child: Text(
            'Reset',
            style: context.bodyLarge,
          ),
        ),
      ),
    );
  }
}
