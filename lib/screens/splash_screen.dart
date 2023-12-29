import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';
import 'package:google_maps_app/screens/map_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateToNextScreen();
  }

  Future<void> navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 4)); // Change the duration as needed

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => MapScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:Container(
          height: 200.0,
          width: 200.0,
          child: LottieBuilder.asset('assets/animations/mapanimation.json'),
        ),
      ),
    );
  }
}
