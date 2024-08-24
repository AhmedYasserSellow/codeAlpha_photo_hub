import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_hub/src/controller/app_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Login',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
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
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: emailController.text,
                  password: passwordController.text,
                );
                final prefs = await SharedPreferences.getInstance();
                prefs.setBool('isLoggedIn', true);
                prefs.setString('email', emailController.text);
                if (context.mounted) {
                  Navigator.pop(context);
                  context.read<AppCubit>().getState();
                }
              } catch (e) {
                Fluttertoast.showToast(
                    msg: 'user name or password is incorrect');
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
                : const Text('Login'),
          ),
          SizedBox(
            height: MediaQuery.of(context).viewInsets.bottom,
          ),
        ],
      ),
    );
  }
}
