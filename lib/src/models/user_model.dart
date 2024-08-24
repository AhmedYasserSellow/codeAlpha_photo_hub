import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userName, email, photoUrl;
  const UserModel({
    required this.userName,
    required this.email,
    required this.photoUrl,
  });

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return UserModel(
      userName: snapshot['name'],
      email: snapshot['email'],
      photoUrl: snapshot['photoUrl'],
    );
  }
}
