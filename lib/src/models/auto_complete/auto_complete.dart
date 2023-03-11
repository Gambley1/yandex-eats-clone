import 'dart:convert' show json;

import 'package:flutter/foundation.dart' show immutable;

@immutable
class AutoComplete {
  final String description;
  final String placeId;
  final String reference;
  final StructuredFormating structuredFormating;
  final List<Terms> terms;
  final List<String> types;
  final List<MatchedSubstrings> matchedSubstrings;
  
  const AutoComplete({
    required this.description,
    required this.placeId,
    required this.reference,
    required this.structuredFormating,
    required this.terms,
    required this.types,
    required this.matchedSubstrings,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'description': description,
      'placeId': placeId,
      'reference': reference,
      'structuredFormating': structuredFormating.toMap(),
      'terms': terms.map((x) => x.toMap()).toList(),
      'types': types,
      'matchedSubstrings': matchedSubstrings.map((x) => x.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());

  factory AutoComplete.fromJson(Map<String, dynamic> json) => AutoComplete(
        description: json["description"] as String,
        placeId: json["place_id"] as String,
        reference: json["reference"] as String,
        structuredFormating:
            StructuredFormating.fromJson(json['structured_formatting']),
        terms: json['terms'] != null
            ? List<Terms>.from(
                (json['terms']).map(
                  (json) => Terms.fromJson(json),
                ),
              )
            : [],
        types: json['types'] != null ? List<String>.from(json['types']) : [],
        matchedSubstrings: json['matched_substrings'] != null
            ? List<MatchedSubstrings>.from(
                (json['matched_substrings']).map<MatchedSubstrings>(
                  (json) => MatchedSubstrings.fromJson(json),
                ),
              )
            : [],
      );

  factory AutoComplete.empty() {
    return AutoComplete(
      description: '',
      placeId: '',
      reference: '',
      structuredFormating: StructuredFormating.empty(),
      terms: const [],
      types: const [],
      matchedSubstrings: const [],
    );
  }
}

@immutable
class StructuredFormating {
  final String mainText;
  final String secondaryText;
  final List<MatchedSubstrings> mainTextMatchedSubstrings;
  const StructuredFormating({
    required this.mainText,
    required this.secondaryText,
    required this.mainTextMatchedSubstrings,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'main_text': mainText,
      'secondary_text': secondaryText,
      'main_text_matched_substrings':
          mainTextMatchedSubstrings.map((x) => x.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());

  factory StructuredFormating.fromJson(Map<String, dynamic> json) =>
      StructuredFormating(
        mainText: json['main_text'] as String,
        secondaryText: json['secondary_text'] ?? '',
        mainTextMatchedSubstrings: json['main_text_matched_substrings'] != null
            ? List<MatchedSubstrings>.from(
                (json['main_text_matched_substrings']).map<MatchedSubstrings>(
                  (json) => MatchedSubstrings.fromJson(json),
                ),
              )
            : [],
      );

  factory StructuredFormating.empty() {
    return const StructuredFormating(
      mainText: '',
      secondaryText: '',
      mainTextMatchedSubstrings: [],
    );
  }
}

@immutable
class MatchedSubstrings {
  final int length;
  final int offset;
  const MatchedSubstrings({
    required this.length,
    required this.offset,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'length': length,
      'offset': offset,
    };
  }

  String toJson() => json.encode(toMap());

  factory MatchedSubstrings.fromJson(Map<String, dynamic> json) =>
      MatchedSubstrings(
        length: json['length'] as int,
        offset: json['offset'] as int,
      );
}

@immutable
class Terms {
  final int offset;
  final String value;
  const Terms({
    required this.offset,
    required this.value,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'offset': offset,
      'value': value,
    };
  }

  String toJson() => json.encode(toMap());

  factory Terms.fromJson(Map<String, dynamic> json) => Terms(
        offset: json['offset'] as int,
        value: json['value'] as String,
      );
}
