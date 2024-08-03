import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';
import 'package:yandex_food_delivery_clone/src/search/search.dart';

class SearchTextField extends StatefulWidget {
  const SearchTextField({required this.controller, super.key});

  final TextEditingController controller;

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  late Debouncer _debouncer;

  @override
  void initState() {
    super.initState();
    _debouncer = Debouncer(milliseconds: 200);
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: SearchBar(
        labelText: quickSearchLabel,
        controller: widget.controller,
        withNavigation: false,
        onChanged: (q) => _debouncer.run(
          () =>
              context.read<SearchBloc>().add(SearchTermChanged(searchTerm: q)),
        ),
      ),
    );
  }
}
