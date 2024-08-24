import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_hub/src/controller/app_cubit.dart';
import 'package:photo_hub/src/utils/routes.dart';
import 'package:photo_hub/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..getState(),
      child: MaterialApp(
        title: 'Photo Hub',
        debugShowCheckedModeBanner: false,
        initialRoute: AppRouter.home,
        routes: AppRouter.routes,
      ),
    );
  }
}
