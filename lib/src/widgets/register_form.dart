import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    super.key,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  XFile? image;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Register',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () async {
              image =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
              setState(() {});
            },
            child: Container(
              width: 100,
              height: 100,
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
          const SizedBox(
            height: 16,
          ),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                setState(() {
                  isLoading = true;
                });
                await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                  email: emailController.text,
                  password: passwordController.text,
                )
                    .then((value) async {
                  Reference refRoot = FirebaseStorage.instance.ref();
                  Reference refImage = refRoot.child(emailController.text);
                  await refImage.putFile(File(image!.path));
                  String photoUrl = await refImage.getDownloadURL();
                  value.user!.updateProfile(
                    displayName: nameController.text,
                    photoURL: photoUrl,
                  );

                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(emailController.text)
                      .set(
                    {
                      'name': nameController.text,
                      'email': emailController.text,
                      'photoUrl': photoUrl,
                    },
                  );
                });
                Fluttertoast.showToast(msg: 'email created successfully');
                if (context.mounted) {
                  Navigator.pop(context);
                }
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  Fluttertoast.showToast(
                      msg: 'The password provided is too weak');
                } else if (e.code == 'email-already-in-use') {
                  Fluttertoast.showToast(
                      msg: 'The account already exists for that email');
                } else {
                  Fluttertoast.showToast(msg: 'use a valid email');
                }
                setState(() {
                  isLoading = false;
                });
              }
            },
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  )
                : const Text('Register'),
          ),
          SizedBox(
            height: MediaQuery.of(context).viewInsets.bottom,
          ),
        ],
      ),
    );
  }
}
