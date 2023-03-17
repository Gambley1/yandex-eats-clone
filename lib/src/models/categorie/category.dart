import 'package:equatable/equatable.dart' show Equatable;
import 'package:flutter/foundation.dart' show immutable;

@immutable
class Category extends Equatable {
  final String name;
  const Category({
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'],
    );
  }

  @override
  List<Object?> get props => <Object?>[
        name,
      ];
}
