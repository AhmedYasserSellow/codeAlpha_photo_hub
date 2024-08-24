import 'package:flutter/material.dart';
import 'package:photo_hub/src/views/home_view.dart';
import 'package:photo_hub/src/views/photo_details_view.dart';
import 'package:photo_hub/src/views/profile_view.dart';
import 'package:photo_hub/src/views/upload_photo.dart';

abstract class AppRouter {
  static const String home = '/home';
  static const String profile = '/profile';
  static const String photoDetails = '/photoDetails';
  static const String uploadPhoto = '/uploadPhoto';

  static Map<String, Widget Function(BuildContext)> routes = {
    home: (BuildContext context) => const HomeView(),
    photoDetails: (BuildContext context) => const PhotoDetailsView(),
    profile: (BuildContext context) => const ProfileView(),
    uploadPhoto: (BuildContext context) => const UploadPhoto(),
  };
}
