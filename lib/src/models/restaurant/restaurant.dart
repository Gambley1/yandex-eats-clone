import 'dart:convert' show json;

import 'package:equatable/equatable.dart' show Equatable;
import 'package:papa_burger/src/restaurant.dart' show Menu;

class Restaurant extends Equatable {
  final String name;
  final String quality;
  final String imageUrl;
  final int id;
  final int numOfRatings;
  final double rating;
  final List<Tag> tags;
  final List<Menu> menu;

  const Restaurant({
    required this.name,
    required this.quality,
    required this.imageUrl,
    required this.id,
    required this.numOfRatings,
    required this.rating,
    required this.tags,
    required this.menu,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'id': id,
      'image_url': imageUrl,
      'quality': quality,
      'rating': rating,
      'numOfRatings': numOfRatings,
      'tags': tags,
      'menu': menu,
    };
  }

  String toJson() => json.encode(toMap());

  const Restaurant.empty()
      : id = 0,
        imageUrl = '',
        name = '',
        quality = '',
        rating = 0,
        numOfRatings = 0,
        tags = const [],
        menu = const [];

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      name: json['name'],
      quality: json['quality'],
      imageUrl: json['image_url'],
      id: json['id'],
      numOfRatings: json['num_of_ratings'],
      rating: json['rating'],
      tags: json['tags'] != null
          ? List<Tag>.from(
              (json['tags']).map<Tag>(
                (json) => Tag.fromJson(json),
              ),
            )
          : [],
      menu: json['menu'] != null
          ? List<Menu>.from(
              (json['menu']).map<Menu>(
                (json) => Menu.fromJson(json),
              ),
            )
          : [],
    );
  }

  String get qualityAndNumOfRatings => '$quality ($numOfRatings+) ';

  List<String> get tagsName => tags.map((e) => e.name).toList();

  String get tagsToString => '';

  @override
  List<Object?> get props => <Object?>[
        name,
        quality,
        imageUrl,
        id,
        numOfRatings,
        rating,
        tags,
        menu,
      ];
}

class Tag extends Equatable {
  final String name;
  final String imageUrl;

  const Tag({
    required this.name,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'image_url': imageUrl,
    };
  }

  String toJson() => json.encode(toMap());

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      name: json['name'] as String,
      imageUrl: json['image_url'] as String,
    );
  }

  @override
  List<Object?> get props => <Object?>[name];
}
