import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:photo_hub/src/models/photo_model.dart';
import 'package:photo_view/photo_view.dart';

class PhotoDetailsView extends StatelessWidget {
  const PhotoDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final PhotoModel photoModel =
        ModalRoute.of(context)!.settings.arguments as PhotoModel;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                const Row(
                  children: [
                    BackButton(),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      photoModel.imageName,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: PhotoView(
                backgroundDecoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor),
                imageProvider: CachedNetworkImageProvider(photoModel.imageUrl),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 16,
                ),
                CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                    photoModel.userImage,
                  ),
                  radius: 32,
                ),
                const SizedBox(
                  width: 16,
                ),
                Text(photoModel.userName),
                const Expanded(
                  child: SizedBox(),
                ),
                IconButton(
                  onPressed: () async {
                    try {
                      await GallerySaver.saveImage(photoModel.imageUrl,
                          albumName: 'PhotoHub');
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Image Downloaded Successfully!')));
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                                'Image Url Problem : Connect with backend developer!')));
                      }
                    }
                  },
                  icon: const Icon(Icons.download),
                ),
                const SizedBox(
                  width: 16,
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
