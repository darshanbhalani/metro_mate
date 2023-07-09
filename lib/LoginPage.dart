import 'package:flutter/material.dart';
import 'package:metro_mate/OTPVarificationPage.dart';
import 'package:metro_mate/Variables.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -200,
            right: -200,
            child: Container(
              height: 400,
              width: 400,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(75, 255, 114, 94),
                  shape: BoxShape.circle
              ),
            ),
          ),
          Positioned(
            top: (MediaQuery.of(context).size.height/2)-150,
            left: -75,
            child: Container(
              height: 150,
              width: 150,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(75, 255, 114, 94),
                  shape: BoxShape.circle
              ),
            ),
          ),
          Positioned(
            top: (MediaQuery.of(context).size.height/2)+20,
            right: -75,
            child: Container(
              height: 150,
              width: 150,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(75, 255, 114, 94),
                  shape: BoxShape.circle
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Center(
              child:SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 200,
                      width: 200,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/LogIn.png")
                          )
                      ),
                    ),
                    const SizedBox(height: 10,),
                    const Text("Phone Varification",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                    const SizedBox(height: 10,),
                    const Text("We need to register your phone"),
                    const Text("before getting started !"),
                    const SizedBox(height: 10,),
                    TFormField(
                        context, "Enter Phone No.", _controller, true, false),

                    const SizedBox(height: 100,),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      bottomSheet: Container(
        color: Colors.transparent,
        // height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: InkWell(
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OTPVarificationPage(phone: _controller.text),
                  ));
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: PrimaryColor,
              ),
              child: Center(child: Text("Send OTP",style: TextStyle(fontSize:20,color: Colors.white),)),
            ),
          ),
        ),
      ),
    );
  }
}
