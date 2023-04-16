import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart'
    show
        AutoComplete,
        CustomCircularIndicator,
        CustomIcon,
        CustomScaffold,
        DisalowIndicator,
        IconType,
        KText,
        LocationBloc,
        LocationResult,
        LocationResultEmpty,
        LocationResultError,
        LocationResultLoading,
        LocationResultNoResults,
        LocationResultWithResults,
        LocationService,
        MyThemeData,
        NavigatorExtension,
        PlaceDetails,
        SearchBar,
        kDefaultHorizontalPadding,
        logger,
        searchLocationLabel;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;

class SearchLocationWithAutoComplete extends StatefulWidget {
  const SearchLocationWithAutoComplete({super.key});

  @override
  State<SearchLocationWithAutoComplete> createState() =>
      _SearchLocationWithAutoCompleteState();
}

class _SearchLocationWithAutoCompleteState
    extends State<SearchLocationWithAutoComplete> {
  final LocationService _locationService = LocationService();

  late final LocationBloc _locationBloc;
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

  _getPlaceDetails(String placeId) async {
    final placeDetails =
        await _locationService.locationApi.getPlaceDetails(placeId);
    _placeDetails = placeDetails;
  }

  _appBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 12, 12, 12),
      child: Row(
        children: [
          CustomIcon(
            type: IconType.iconButton,
            onPressed: () => context.pop(),
            icon: FontAwesomeIcons.arrowLeft,
            size: 22,
          ),
          Expanded(
            child: SearchBar(
              onChanged: _locationBloc.search.add,
              labelText: searchLocationLabel,
              withNavigation: false,
            ),
          ),
        ],
      ),
    );
  }

  _buildError(String error) => KText(text: error);

  _buildLoading() => const CustomCircularIndicator(color: Colors.black);

  _buildNoResults() => const KText(
        text: 'No results by your search term.',
        size: 20,
      );

  _buildEmpty() => Container();

  _buildResults(BuildContext context, List<AutoComplete> results) => Expanded(
        child: ListView.builder(
          itemBuilder: (context, index) {
            final autoCompleteLoc = results[index];
            final mainText = autoCompleteLoc.structuredFormating.mainText;
            final secondaryText =
                autoCompleteLoc.structuredFormating.secondaryText;

            final placeId = autoCompleteLoc.placeId;
            _getPlaceDetails(placeId);
            final isOk = _placeDetails != null
                ? _placeDetails!.formattedAddress.isNotEmpty
                : false;
            return InkWell(
              onTap: () {
                isOk ? context.navigateToGoolgeMapView(_placeDetails!) : null;
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultHorizontalPadding,
                    vertical: kDefaultHorizontalPadding),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    KText(
                      text: mainText,
                      size: 18,
                      maxLines: 2,
                    ),
                    KText(
                      text: secondaryText,
                      size: 14,
                      color: Colors.grey,
                      maxLines: 1,
                    )
                  ],
                ),
              ),
            );
          },
          itemCount: results.length,
        ).disalowIndicator(),
      );

  _buildUnhandledState() => const KText(text: 'Unhandled state');

  _buildUi(BuildContext context) {
    return CustomScaffold(
      withReleaseFocus: true,
      withSafeArea: true,
      body: Column(
        children: [
          _appBar(context),
          StreamBuilder<LocationResult?>(
            stream: _locationBloc.result,
            builder: (context, snapshot) {
              final location = snapshot.data;
              logger.w('$location');
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

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: MyThemeData.globalThemeData,
      child: Builder(
        builder: (context) {
          return _buildUi(context);
        },
      ),
    );
  }
}
