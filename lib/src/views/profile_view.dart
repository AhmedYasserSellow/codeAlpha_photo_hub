import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:photo_hub/src/controller/app_cubit.dart';
import 'package:photo_hub/src/models/photo_model.dart';
import 'package:photo_hub/src/models/user_model.dart';
import 'package:photo_hub/src/utils/routes.dart';
import 'package:photo_hub/src/views/auth_view.dart';
import 'package:photo_hub/src/widgets/photo_hub_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        if (context.read<AppCubit>().email == null) {
          return const AuthView();
        } else {
          return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(context.read<AppCubit>().email)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final UserModel userModel =
                      UserModel.fromSnapshot(snapshot.data!);
                  return Scaffold(
                    appBar: AppBar(
                      centerTitle: true,
                      title: const Text('Your Profile'),
                      actions: [
                        IconButton(
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setBool('isLoggedIn', false);
                            prefs.remove('email');
                            if (context.mounted) {
                              context.read<AppCubit>().getState();
                            }
                          },
                          icon: const Icon(
                            Icons.logout,
                          ),
                        ),
                      ],
                    ),
                    body: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(
                                  userModel.photoUrl),
                              radius: 75,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              userModel.userName,
                              style: const TextStyle(fontSize: 24),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(userModel.email)
                                    .collection('photos')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data!.docs.isNotEmpty) {
                                      return Expanded(
                                        child: MasonryGridView.builder(
                                          itemCount: snapshot.data!.docs.length,
                                          gridDelegate:
                                              const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                          ),
                                          mainAxisSpacing: 16,
                                          crossAxisSpacing: 8,
                                          itemBuilder: (context, index) {
                                            return PhotoHubImage(
                                                photoModel:
                                                    PhotoModel.fromSnapshot(
                                              snapshot.data!.docs[index],
                                            ));
                                          },
                                        ),
                                      );
                                    } else {
                                      return const Expanded(
                                        child: Center(
                                            child: Text(
                                          'No photos yet',
                                          style: TextStyle(
                                            fontSize: 22,
                                          ),
                                        )),
                                      );
                                    }
                                  } else {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                })
                          ],
                        ),
                      ),
                    ),
                    floatingActionButton: FloatingActionButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRouter.uploadPhoto,
                            arguments: userModel);
                      },
                      backgroundColor: Colors.white,
                      child: const Icon(
                        Icons.add,
                      ),
                    ),
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.centerFloat,
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              });
        }
      },
    );
  }
}
