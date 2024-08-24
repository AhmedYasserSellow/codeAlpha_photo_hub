import 'package:flutter/material.dart';
import 'package:photo_hub/src/widgets/login_form.dart';
import 'package:photo_hub/src/widgets/register_form.dart';

class AuthView extends StatelessWidget {
  const AuthView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome Guest'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Join us to add your artwork',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return const LoginForm();
                      },
                    );
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return const RegisterForm();
                      },
                    );
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
