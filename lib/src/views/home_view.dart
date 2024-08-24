import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:photo_hub/src/models/photo_model.dart';
import 'package:photo_hub/src/utils/routes.dart';
import 'package:photo_hub/src/widgets/paginator.dart';
import 'package:photo_hub/src/widgets/photo_hub_image.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  PageController pageController = PageController();
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Hub'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRouter.profile,
              );
            },
            icon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/images/user.png'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('photos').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Paginator(
                        currentIndex: currentIndex,
                        onPageChanged: (index) {
                          setState(() {
                            currentIndex = index - 1;
                            pageController.animateToPage(currentIndex,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut);
                          });
                        },
                        totalPages: (snapshot.data!.docs.length / 10).ceil(),
                      ),
                      Expanded(
                        child: PageView.builder(
                          controller: pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return MasonryGridView.builder(
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 8,
                              itemBuilder: (context, index) {
                                return PhotoHubImage(
                                  photoModel: PhotoModel.fromSnapshot(
                                    snapshot.data!
                                        .docs[(currentIndex * 10) + index],
                                  ),
                                );
                              },
                              itemCount: 10,
                              gridDelegate:
                                  const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}
