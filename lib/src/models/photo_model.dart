import 'package:cloud_firestore/cloud_firestore.dart';

class PhotoModel {
  final String imageUrl;
  final String imageName;
  final String userImage;
  final String userName;
  const PhotoModel(
      {required this.imageUrl,
      required this.imageName,
      required this.userImage,
      required this.userName});

  factory PhotoModel.fromSnapshot(DocumentSnapshot snapshot) {
    return PhotoModel(
      imageUrl: snapshot['url'],
      imageName: snapshot['name'],
      userImage: snapshot['user_name_photo'],
      userName: snapshot['user_name'],
    );
  }
  toJson() {
    return {
      'url': imageUrl,
      'name': imageName,
      'user_name_photo': userImage,
      'user_name': userName
    };
  }
}
