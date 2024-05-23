// ignore_for_file: public_member_api_docs, sort_constructors_first
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

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'name': username,
        'profilePicture': profilePicture,
        'isPremiumActive': isPremiumActive,
      };

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] as String,
      email: map['email'] as String,
      username: map['name'] as String,
      profilePicture: map['profilePicture'] as String,
      isPremiumActive: map['isPremiumActive'] as bool,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        uid,
        email,
        username,
        profilePicture,
        isPremiumActive,
      ];
}
