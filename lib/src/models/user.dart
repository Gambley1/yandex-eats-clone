// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:papa_burger_server/api.dart' as server;

class User extends Equatable {
  const User({
    required this.uid,
    required this.email,
    required this.username,
    required this.profilePicture,
    required this.isPremiumActive,
  });

  final String uid;
  final String email;
  final String username;
  final String profilePicture;
  final bool isPremiumActive;

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  const User.empty()
      : uid = '',
        email = '',
        username = 'Unknown',
        profilePicture = '',
        isPremiumActive = false;

  factory User.fromDb(server.User user) => User(
        uid: user.uid,
        email: user.email,
        username: user.name,
        profilePicture: user.profilePicture,
        isPremiumActive: user.isPremiumActive,
      );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'name': username,
      'profilePicture': profilePicture,
      'isPremiumActive': isPremiumActive,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] as String,
      email: map['email'] as String,
      username: map['name'] as String,
      profilePicture: map['profilePicture'] as String,
      isPremiumActive: map['isPremiumActive'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  List<Object?> get props => <Object?>[
        uid,
        email,
        username,
        profilePicture,
        isPremiumActive,
      ];
}
