import 'package:ecommerce_app/controllers/home_controller.dart';
import 'package:ecommerce_app/controllers/user_controller.dart';
import 'package:ecommerce_app/views/splash_screen/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../auth_screen/login_screen.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // user is already is logged in
            return const SplashScreen();
          } else {
            // user is not logged in
            try {
              Get.find<UserController>().dispose();
              Get.find<HomeController>().dispose();
              print('hora kaam yaha pe kuch...');
            } catch (e) {
              // ignore
            }
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
