import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:metro_mate/LogIn/MainPage.dart';
import 'package:metro_mate/LogIn/SplashScreenPage.dart';
import 'package:metro_mate/firebase_options.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        title: "Metro Mate",
        debugShowCheckedModeBanner: false,
        // home: MainPage(),
        home: SplashScreen(),
      ),
    );
  }
}


