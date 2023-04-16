import 'package:flutter/material.dart';
import 'package:papa_burger/src/restaurant.dart'
    show
        AppInputText,
        NavigatorExtension,
        kDefaultSearchBarRadius,
        searchFoodLabel;
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;

class SearchBar extends StatelessWidget {
  const SearchBar({
    super.key,
    this.withNavigation = true,
    this.enabled = true,
    this.labelText = searchFoodLabel,
    this.onChanged,
  });

  final bool withNavigation, enabled;
  final String labelText;
  final dynamic Function(String term)? onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => withNavigation ? context.navigateToSearchView() : () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(kDefaultSearchBarRadius),
        ),
        child: AppInputText(
          enabled: enabled,
          enabledBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: labelText,
          onChanged: onChanged,
          borderRadius: kDefaultSearchBarRadius,
          prefixIcon: const Icon(
            FontAwesomeIcons.magnifyingGlass,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
