import 'package:flutter/material.dart';
import 'package:metro_mate/LogIn/MainPage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _animationController!.forward();
    _animationController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Animation has completed, navigate to the main screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => MainPage(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController!,
      builder: (BuildContext context, Widget? child) {
        return Scaffold(
          body: Center(
            child: FadeTransition(
              opacity: _animationController!,
              child: child,
            ),
          ),
        );
      },
      child: YourSplashScreenContent(), // Replace with your own splash screen content
    );
  }
}

class YourSplashScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width * 0.7,
              child: Image.asset('assets/images/Splash.png')),
          SizedBox(height: 30,)
        ],
      ),
    );
  }
}
