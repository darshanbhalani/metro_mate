import 'package:flutter/material.dart';
import 'package:metro_mate/Variables.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  TextEditingController controller1 =TextEditingController();
  TextEditingController controller2 =TextEditingController();
  TextEditingController controller3 =TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool flag=false;

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _key,
        child: Stack(
          children: [
            Positioned(
              top: -200,
              right: -200,
              child: Container(
                height: 400,
                width: 400,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(75, 255, 114, 94),
                    shape: BoxShape.circle),
              ),
            ),
            Positioned(
              top: (MediaQuery.of(context).size.height / 2) - 150,
              left: -75,
              child: Container(
                height: 150,
                width: 150,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(75, 255, 114, 94),
                    shape: BoxShape.circle),
              ),
            ),
            Positioned(
              top: (MediaQuery.of(context).size.height / 2) + 20,
              right: -75,
              child: Container(
                height: 150,
                width: 150,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(75, 255, 114, 94),
                    shape: BoxShape.circle),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 200,
                        width: 200,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/images/SignUp.png"))),
                      ),
                      const Text("We need some information about you"),
                      const Text("before getting started !"),
                      const SizedBox(
                        height: 10,
                      ),
                      Visibility(
                          visible: flag,
                          child: const Text("User Already Exists. Please try to Login !!",style: TextStyle(color: Colors.red,fontSize: 15),)),
                      Visibility(
                        visible: flag,
                          child: const SizedBox(height: 10,)),
                      TFormField(
                          context, "First Name", controller1, true, false),
                      TFormField(
                          context, "Last Name", controller2, true, false),
                      TFormField(
                          context, "Phone No.", controller3, true, false),
                      const SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: GestureDetector(
            onTap: () async {
              if (_key.currentState!.validate() && controller3.text.length == 10) {
                cuFName=controller1.text.trim().toString().toUpperCase();
                cuLName=controller2.text.trim().toString().toUpperCase();
                cuPhone=controller3.text.trim().toString();
                Loading(context);
                var snapShot = await fire.collection("Users").doc(controller3.text.toString()).get();
                if(!snapShot.exists){
                  await SendOTP(context, controller3.text.toString(),true,"signup");
                }else{
                  flag=true;
                  setState(() {
                  });
                  Navigator.pop(context);
                }
              }
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: PrimaryColor,
              ),
              child:const Center(
                  child: Text(
                    "Send OTP",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
