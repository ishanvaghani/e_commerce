import 'dart:async';

import 'package:e_commerce/screens/home_page.dart';
import 'package:e_commerce/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  bool isExistingUser() {
    if(FirebaseAuth.instance.currentUser != null) {
      return true;
    }
    else {
      return false;
    }
  }

 @override
  void initState() {
    super.initState();
    if (isExistingUser()) {
      Timer(
        Duration(seconds: 2),
        () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        ),
      );
    } else {
      Timer(
        Duration(seconds: 2),
        () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Image.asset(
            'assets/images/splash_logo.png',
            fit: BoxFit.cover,
            height: 200,
            width: 200,
          ),
        ),
      ),
    );
  }
}
