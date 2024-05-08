import 'dart:async';
import 'package:circule_game/pages/home_page.dart';
import 'package:flutter/material.dart';
import '../navigation_service.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  SplashViewState createState() => SplashViewState();
}

class SplashViewState extends State<SplashView> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(const Duration(seconds: 3), () {
        navigateToMainScreen();
      });
    });
  }

  void navigateToMainScreen() {
    Navigator.pushReplacement(
      NavigationService.navigatorKey.currentContext ?? context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:  Center(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Image.asset(
            'assets/images/home.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
}