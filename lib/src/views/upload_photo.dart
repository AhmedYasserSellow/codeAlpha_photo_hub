import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_hub/src/models/photo_model.dart';
import 'package:photo_hub/src/models/user_model.dart';

class UploadPhoto extends StatefulWidget {
  const UploadPhoto({super.key});

  @override
  State<UploadPhoto> createState() => _UploadPhotoState();
}

class _UploadPhotoState extends State<UploadPhoto> {
  final TextEditingController nameController = TextEditingController();
  XFile? image;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final UserModel userModel =
        ModalRoute.of(context)!.settings.arguments as UserModel;
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text(
          'Upload a Photo',
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  image = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  setState(() {});
                },
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        )),
                    child: image == null
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image,
                                size: 50,
                                color: Colors.black,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                'Add Image',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              )
                            ],
                          )
                        : Image.file(File(image!.path), fit: BoxFit.cover),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Photo Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  String name = nameController.text.replaceAll(' ', '_');
                  Reference refRoot = FirebaseStorage.instance.ref();
                  Reference refImage = refRoot.child(name);
                  await refImage.putFile(File(image!.path));
                  String photoUrl = await refImage.getDownloadURL();
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(userModel.email)
                      .collection('photos')
                      .add(
                        PhotoModel(
                          imageUrl: photoUrl,
                          imageName: nameController.text,
                          userImage: userModel.photoUrl,
                          userName: userModel.userName,
                        ).toJson(),
                      )
                      .then((value) {
                    FirebaseFirestore.instance
                        .collection('photos')
                        .doc(value.id)
                        .set(
                          PhotoModel(
                            imageUrl: photoUrl,
                            imageName: nameController.text,
                            userImage: userModel.photoUrl,
                            userName: userModel.userName,
                          ).toJson(),
                        );
                  });

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      )
                    : const Text(
                        'Upload',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
