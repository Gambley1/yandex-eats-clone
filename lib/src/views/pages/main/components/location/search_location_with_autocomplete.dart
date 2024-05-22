// ignore_for_file: unnecessary_statements, unnecessary_null_checks

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/models/models.dart';
import 'package:papa_burger/src/views/pages/main/components/search/search_bar.dart';
import 'package:papa_burger/src/views/pages/main/services/services.dart';
import 'package:papa_burger/src/views/pages/main/state/location_bloc.dart';
import 'package:papa_burger/src/views/pages/main/state/location_result.dart';
import 'package:papa_burger/src/views/widgets/widgets.dart';

class SearchLocationView extends StatefulWidget {
  const SearchLocationView({super.key});

  @override
  State<SearchLocationView> createState() => _SearchLocationViewState();
}

class _SearchLocationViewState extends State<SearchLocationView> {
  final LocationService _locationService = LocationService();

  late LocationBloc _locationBloc;
  PlaceDetails? _placeDetails;

  @override
  void initState() {
    super.initState();
    _locationBloc = _locationService.locationBloc;
  }

  @override
  void dispose() {
    _locationBloc.dispose();
    super.dispose();
  }

  Future<void> _getPlaceDetails(String placeId) async {
    final placeDetails =
        await _locationService.locationApi.getPlaceDetails(placeId);
    _placeDetails = placeDetails;
  }

  Widget _appBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 12, 12, 12),
      child: Row(
        children: [
          CustomIcon(
            type: IconType.iconButton,
            onPressed: () => context.pop(),
            icon: FontAwesomeIcons.arrowLeft,
          ),
          Expanded(
            child: CustomSearchBar(
              onChanged: _locationBloc.search.add,
              labelText: searchLocationLabel,
              withNavigation: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String error) => Text(error);

  Widget _buildLoading() => const CustomCircularIndicator(color: Colors.black);

  Widget _buildNoResults() => Text(
        'No results by your search term.',
        style: context.titleLarge,
      );

  Widget _buildEmpty() => const SizedBox.shrink();

  Widget _buildResults(BuildContext context, List<AutoComplete> results) =>
      Expanded(
        child: ListView.builder(
          itemBuilder: (context, index) {
            final autoCompleteLoc = results[index];
            final mainText = autoCompleteLoc.structuredFormatting.mainText;
            final secondaryText =
                autoCompleteLoc.structuredFormatting.secondaryText;

            final placeId = autoCompleteLoc.placeId;
            _getPlaceDetails(placeId);
            final isOk = _placeDetails != null &&
                _placeDetails!.formattedAddress.isNotEmpty;
            return InkWell(
              onTap: () {
                isOk ? context.goToGoogleMap(_placeDetails!) : null;
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultHorizontalPadding,
                  vertical: kDefaultHorizontalPadding,
                ),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mainText,
                      style: context.bodyLarge,
                    ),
                    Text(
                      secondaryText,
                      maxLines: 1,
                      style: context.bodyMedium?.apply(color: AppColors.grey),
                    ),
                  ],
                ),
              ),
            );
          },
          itemCount: results.length,
        ),
      );

  Widget _buildUnhandledState() => const Text('Unhandled state');

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      releaseFocus: true,
      body: Column(
        children: [
          _appBar(context),
          StreamBuilder<LocationResult?>(
            stream: _locationBloc.result,
            builder: (context, snapshot) {
              final location = snapshot.data;
              if (location is LocationResultError) {
                final error = location.error.toString();
                return _buildError(error);
              }
              if (location is LocationResultLoading) {
                return _buildLoading();
              }
              if (location is LocationResultNoResults) {
                return _buildNoResults();
              }
              if (location is LocationResultEmpty) {
                return _buildEmpty();
              }
              if (location is LocationResultWithResults) {
                final results = location.autoCompletes;
                return _buildResults(context, results);
              }
              return _buildUnhandledState();
            },
          ),
        ],
      ),
    );
  }
}
