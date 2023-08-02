import 'package:flutter/material.dart';
import 'package:metro_mate/LogIn/MainPage.dart';
import 'package:metro_mate/MainScreen/Home/HomePage.dart';
import 'package:metro_mate/Variables.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

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
      duration: const Duration(seconds: 2),
    );
    _animationController!.forward();
    _animationController!.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        if(auth.currentUser == null){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const MainPage(),
            ),
          );
        }else{
          await getLocalDetails();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ));
        }

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
      child: const YourSplashScreenContent(), // Replace with your own splash screen content
    );
  }
}

class YourSplashScreenContent extends StatelessWidget {
  const YourSplashScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width * 0.7,
              child: Image.asset('assets/images/Splash.png')),
          const SizedBox(height: 30,)
        ],
      ),
    );
  }
}
