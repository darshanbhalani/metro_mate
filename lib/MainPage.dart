import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:metro_mate/LoginPage.dart';
import 'package:metro_mate/SignUpPage.dart';
import 'package:metro_mate/Variables.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
              bottom: -20,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset('assets/images/Train.png'))),
          Positioned(
            top: -150,
            right: -150,
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                  color: Color.fromARGB(75, 255, 114, 94),
                  shape: BoxShape.circle
              ),
            ),
          ),
          Positioned(
            bottom: (MediaQuery.of(context).size.height/2)-20,
            left: -75,
            child: Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                  color: Color.fromARGB(75, 255, 114, 94),
                  shape: BoxShape.circle
              ),
            ),
          ),
          Positioned(
            bottom: (MediaQuery.of(context).size.height/2)-200,
            right: -75,
            child: Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                  color: Color.fromARGB(75, 255, 114, 94),
                  shape: BoxShape.circle
              ),
            ),
          ),
          Positioned(
            bottom: -75,
            left: -75,
            child: Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                  color: Color.fromARGB(75, 255, 114, 94),
                  shape: BoxShape.circle
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: Text("WELCOME",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 40),)),
                SizedBox(height: 35,),
                InkWell(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ));
                  },
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: PrimaryColor,
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: Center(child: Text("Log In",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white),)),
                  ),
                ),
                SizedBox(height: 15,),
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 36),
                    children: <TextSpan>[
                      TextSpan(text: "New Member ? "),
                      TextSpan(
                          text: "Click here",style: TextStyle(color: PrimaryColor),
                          recognizer:TapGestureRecognizer()..onTap = (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignUpPage(),
                                ));
                          }
                      ),
                    ],
                  ),
                  textScaleFactor: 0.4,
                ),
                SizedBox(height: 35,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
