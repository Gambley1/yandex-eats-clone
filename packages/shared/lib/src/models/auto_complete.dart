class AutoComplete {
  const AutoComplete({
    required this.description,
    required this.placeId,
    required this.reference,
    required this.structuredFormatting,
    required this.terms,
    required this.types,
    required this.matchedSubstrings,
  });

  factory AutoComplete.fromJson(Map<String, dynamic> json) => AutoComplete(
        description: json['description'] as String,
        placeId: json['place_id'] as String,
        reference: json['reference'] as String,
        structuredFormatting: StructuredFormatting.fromJson(
          json['structured_formatting'] as Map<String, dynamic>,
        ),
        terms: [],
        types: json['types'] != null
            ? List<dynamic>.from(json['types'] as List).cast<String>()
            : [],
        matchedSubstrings: [],
      );

  final String description;
  final String placeId;
  final String reference;
  final StructuredFormatting? structuredFormatting;
  final List<Terms> terms;
  final List<String> types;
  final List<MatchedSubstrings> matchedSubstrings;

  Map<String, dynamic> toJson() => {
        'description': description,
        'place_id': placeId,
        'reference': reference,
        'structured_formatting': structuredFormatting?.toJson(),
        'terms': terms.map((x) => x.toJson()).toList(),
        'types': types,
        'matched_substrings': matchedSubstrings.map((x) => x.toJson()).toList(),
      };
}

class StructuredFormatting {
  const StructuredFormatting({
    required this.mainText,
    required this.secondaryText,
    required this.mainTextMatchedSubstrings,
  });

  factory StructuredFormatting.fromJson(Map<String, dynamic> json) =>
      StructuredFormatting(
        mainText: json['main_text'] as String?,
        secondaryText: json['secondary_text'] as String?,
        mainTextMatchedSubstrings: json['main_text_matched_substrings'] != null
            ? List<dynamic>.from(
                json['main_text_matched_substrings'] as List,
              )
                .map(
                  (e) => MatchedSubstrings.fromJson(e as Map<String, dynamic>),
                )
                .toList()
            : [],
      );

  final String? mainText;
  final String? secondaryText;
  final List<MatchedSubstrings> mainTextMatchedSubstrings;

  Map<String, dynamic> toJson() => {
        'main_text': mainText,
        'secondary_text': secondaryText,
        'main_text_matched_substrings':
            mainTextMatchedSubstrings.map((x) => x.toJson()).toList(),
      };
}

class MatchedSubstrings {
  const MatchedSubstrings({
    required this.length,
    required this.offset,
  });

  factory MatchedSubstrings.fromJson(Map<String, dynamic> json) =>
      MatchedSubstrings(
        length: json['length'] as int,
        offset: json['offset'] as int,
      );

  final int length;
  final int offset;

  Map<String, dynamic> toJson() => {
        'length': length,
        'offset': offset,
      };
}

class Terms {
  const Terms({
    required this.offset,
    required this.value,
  });

  factory Terms.fromJson(Map<String, dynamic> json) => Terms(
        offset: json['offset'] as int,
        value: json['value'] as String,
      );

  final int offset;
  final String value;

  Map<String, dynamic> toJson() => {
        'offset': offset,
        'value': value,
      };
}
