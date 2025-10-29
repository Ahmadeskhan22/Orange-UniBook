import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String id;
  final String email;
  final String? name;
  final String? photoUrl;
  final String? phoneNumber;

  UserModel({
    required this.id,
    required this.email,
    this.name,
    this.photoUrl,
    this.phoneNumber,
  });

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName,
      photoUrl: user.photoURL,
      phoneNumber: user.phoneNumber,
    );
  }
}
