import 'dart:async';
import 'package:crucks/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  void _navigateAfter() {
    print("done timer");
    // Get.to(MyHomePage());
    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => MyHomePage()));
  }

  void startTimer() {
    Timer(const Duration(seconds: 3), _navigateAfter);
  }

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..forward();
    animation = CurvedAnimation(parent: controller, curve: Curves.bounceInOut);

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: animation,
            child: Center(
                //     child: Image.asset(
                //   "lib/hipi.png",
                //   width: 250,
                // )
                child: Text("Welcome to FeelMeal",
                    style: TextStyle(fontSize: 28, color: Colors.white))),
          ),
        ],
      ),
    );
  }
}
