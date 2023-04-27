import 'package:expensefirebase/homepage.dart';
import 'package:expensefirebase/provider/authProvider.dart';
import 'package:expensefirebase/utils/routers.dart';
import 'package:expensefirebase/utils/showalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
        child: Text("Sign in with Google"),
        onPressed: () {
          AuthenticationProvider().signInWithGoogle().then((value) {
            nextPageOnly(page: HomePage(), context: context);
          }).catchError((e) {
            showAlert(context, e.toString());
          });
        },
      )),
    );
  }
}
