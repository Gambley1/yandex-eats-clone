import 'package:equatable/equatable.dart' show Equatable;
import 'package:flutter/foundation.dart' show immutable;

@immutable
class Category extends Equatable {
  const Category({
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'] as String,
    );
  }
  final String name;

  @override
  List<Object?> get props => <Object?>[
        name,
      ];
}
