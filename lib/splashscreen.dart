import 'package:expensefirebase/authscreen.dart';
import 'package:expensefirebase/homepage.dart';
import 'package:expensefirebase/utils/routers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    //show screen for 2 secs
    Future.delayed(const Duration(seconds: 2), () {
      //if user is authenticated then move to AuthPage else move to MainActivityPage
      if (auth.currentUser == null) {
        nextPageOnly(context: context, page: AuthScreen());
      } else {
        nextPageOnly(context: context, page: const HomePage());
      }
    });

    return Scaffold(
      body: Center(
          child: Image.asset("assets/images/A.png")
      ),
    );
  }
}
