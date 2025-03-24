import 'dart:async';
import 'package:flutter/material.dart';
import 'package:GrocerApp/pages/WelcomeScreen.dart';
import 'package:GrocerApp/pages/Dashboard/Dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../LocalStorageHelper/LocalAuthService.dart';
import '../LocalStorageHelper/LocalStorageService.dart';
import '../theme/app_theme.dart';

class splash_screen extends StatefulWidget {
  const splash_screen({Key? key}) : super(key: key);

  @override
  State<splash_screen> createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animations
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.7, curve: Curves.easeIn),
      ),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.3, 1.0, curve: Curves.easeOutBack),
      ),
    );
    
    _animationController.forward();
    
    // Navigate after splash screen delay
    Timer(Duration(seconds: 3), () {
      navigateToNextScreen();
    });
  }

  Future<void> navigateToNextScreen() async {
    try {
      // Initialize local storage data first
      await LocalStorageService.initializeData();
      
      // Check if user is logged in
      final user = await LocalAuthService.getCurrentUser();
      
      if (user != null) {
        // User is logged in, navigate to dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
        );
      } else {
        // User is not logged in, navigate to welcome screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Welcomescreen()),
        );
      }
    } catch (e) {
      print('Error in splash screen: $e');
      // If any error occurs, go to welcome screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Welcomescreen()),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/applogo_1.png',
                      width: 150,
                      height: 150,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'FreshBasket',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Fresh groceries at your doorstep',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}





