import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_hub/src/models/photo_model.dart';
import 'package:photo_hub/src/utils/routes.dart';

class PhotoHubImage extends StatelessWidget {
  const PhotoHubImage({
    super.key,
    required this.photoModel,
  });

  final PhotoModel photoModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRouter.photoDetails, arguments: photoModel);
      },
      child: CachedNetworkImage(imageUrl: photoModel.imageUrl),
    );
  }
}
