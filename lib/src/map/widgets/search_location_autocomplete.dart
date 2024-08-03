import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:location_repository/location_repository.dart';
import 'package:shared/shared.dart';
import 'package:yandex_food_delivery_clone/src/map/map.dart';
import 'package:yandex_food_delivery_clone/src/search/widgets/search_bar.dart';

class SearchLocationAutoCompletePage extends StatelessWidget {
  const SearchLocationAutoCompletePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AutoCompleteBloc(
        locationRepository: context.read<LocationRepository>(),
      ),
      child: const SearchLocationAutoCompleteView(),
    );
  }
}

class SearchLocationAutoCompleteView extends StatefulWidget {
  const SearchLocationAutoCompleteView({super.key});

  @override
  State<SearchLocationAutoCompleteView> createState() =>
      _SearchLocationAutoCompleteViewState();
}

class _SearchLocationAutoCompleteViewState
    extends State<SearchLocationAutoCompleteView> {
  late Debouncer _debouncer;

  @override
  void initState() {
    super.initState();
    _debouncer = Debouncer(milliseconds: 300);
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        context.select((AutoCompleteBloc bloc) => bloc.state.status.isLoading);

    return AppScaffold(
      releaseFocus: true,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              0,
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
            ),
            child: Row(
              children: [
                AppIcon.button(
                  onTap: context.pop,
                  icon: Icons.adaptive.arrow_back_sharp,
                ),
                Expanded(
                  child: SearchBar(
                    onChanged: (q) => _debouncer.run(
                      () => context
                          .read<AutoCompleteBloc>()
                          .add(AutoCompleteFetchRequested(searchTerm: q)),
                    ),
                    labelText: searchLocationLabel,
                    withNavigation: false,
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            const AppCircularProgressIndicator()
          else
            const AutoCompletesListView(),
        ],
      ),
    );
  }
}
