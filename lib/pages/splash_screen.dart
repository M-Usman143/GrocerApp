import 'dart:async';
import 'package:flutter/material.dart';
import 'package:GrocerApp/pages/Dashboard.dart';
import 'package:GrocerApp/pages/LocationScreen.dart';
import 'package:GrocerApp/pages/WelcomeScreen.dart';
import 'package:GrocerApp/pages/login.dart';
import 'package:GrocerApp/pages/sign_up.dart';

import '../Common/SharedPreferenceHelper.dart';


class splash_screen extends StatefulWidget {
  const splash_screen({super.key});



  @override
  State<splash_screen> createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 3));
    String? phoneNumber = await SharedPreferencesHelper.getPhoneNumber();
    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Dashbaord()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Welcomescreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo or Splash Image
              Image.asset(
                'assets/images/splashimage.jpg',
                width: 250,
                height: 250,
              ),
            ],
          ),
        ),
      ),
    );
  }
}





