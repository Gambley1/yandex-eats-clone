import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:papa_burger/src/restaurant.dart';

class SearchLocationWithAutoComplete extends StatefulWidget {
  const SearchLocationWithAutoComplete({super.key});

  @override
  State<SearchLocationWithAutoComplete> createState() =>
      _SearchLocationWithAutoCompleteState();
}

class _SearchLocationWithAutoCompleteState
    extends State<SearchLocationWithAutoComplete> {
  final LocationService _locationService = LocationService();

  @override
  void dispose() {
    _locationService.locationBloc.dispose();
    super.dispose();
  }

  _appBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 12, 12, 12),
      child: Row(
        children: [
          CustomIcon(
            type: IconType.iconButton,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: FontAwesomeIcons.arrowLeft,
            size: 22,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(kDefaultSearchBarRadius),
              ),
              child: AppInputText(
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                labelText: 'Search...',
                onChanged: _locationService.locSearch.add,
                prefixIcon: const Icon(
                  FontAwesomeIcons.magnifyingGlass,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildUi(BuildContext context) {
    return GestureDetector(
      onTap: () => _releaseFocus(context),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              _appBar(context),
              StreamBuilder(
                stream: _locationService.streamLocResult,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final location = snapshot.data;
                    if (location is LocationResultError) {
                      return KText(text: location.error.toString());
                    } else if (location is LocationResultLoading) {
                      return const CustomCircularIndicator(color: Colors.black);
                    } else if (location is LocationResultNoResults) {
                      return const KText(
                        text: 'No results by your search term.',
                        size: 20,
                      );
                    } else if (location is LocationResultWithResults) {
                      final automCompleteLocations = location.autoCompletes;
                      return Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            final autoCompleteLoc =
                                automCompleteLocations[index];
                            final mainText =
                                autoCompleteLoc.structuredFormating.mainText;
                            final secondaryText = autoCompleteLoc
                                .structuredFormating.secondaryText;
                            return InkWell(
                              onTap: () {},
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
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: automCompleteLocations.length,
                        ).disalowIndicator(),
                      );
                    } else {
                      return const KText(text: 'Unhandled statate');
                    }
                  } else {
                    return const KText(text: '');
                  }
                },
              ),
            ],
          ),
        ),
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

  void _releaseFocus(BuildContext context) => FocusScope.of(context).unfocus();
}
