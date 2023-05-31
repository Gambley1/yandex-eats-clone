import 'dart:convert';

import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.uid,
    required this.email,
    required this.username,
    required this.profilePicture,
    required this.isPremiumActive,
  });

  factory User.fromJson(String source) =>
      User.fromMap(jsonDecode(source) as Map<String, dynamic>);

  const User.empty()
      : uid = '',
        email = '',
        username = 'Unknown',
        profilePicture = '',
        isPremiumActive = false;

  factory User.fromMap(Map<String, dynamic> json) => User(
        uid: json['uid'] as String,
        username: json['name'] as String,
        email: json['email'] as String,
        profilePicture: json['profilePicture'] as String,
        isPremiumActive: json['isPremiumActive'] as bool,
      );
  final String uid;
  final String email;
  final String username;
  final String profilePicture;
  final bool isPremiumActive;

  @override
  List<Object?> get props => <Object?>[
        uid,
        email,
        username,
        profilePicture,
        isPremiumActive,
      ];
}
