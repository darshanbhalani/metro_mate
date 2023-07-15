import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metro_mate/MainScreen/Home/HomePage.dart';
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
                          child: Text("User Already Exists. Please try to Login !!",style: TextStyle(color: Colors.red,fontSize: 15),)),
                      Visibility(
                        visible: flag,
                          child: SizedBox(height: 10,)),
                      Box(context, "First Name", controller1),
                      Box(context, "Last Name", controller2),
                      Box(context, "Phone No.", controller3),
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
      bottomSheet: InkWell(
        onTap: () async {
          if(_key.currentState!.validate()){
            // Loading(context);
            var snapShot = await fire.collection("Users").doc(controller3.text.toString()).get();
            if(!snapShot.exists){
              await SendOTP(context, controller3.text.toString());
              // await SignUp(controller1.text.toString(), controller2.text.toString(), controller3.text.toString());
              // await getUserData(controller3.text.toString());
              // Navigator.pop(context);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => HomePage()),
              // );
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => OTPVarificationPage(phone: controller3.text.toString()),
              //     ));
            }else{
              flag=true;
              setState(() {
              });
              Navigator.pop(context);
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: PrimaryColor,
            ),
            child: const Center(child: Text("Submit",style: TextStyle(fontSize:20,color: Colors.white),)),
          ),
        ),
      ),
    );
  }

  Box(context, String _lable, TextEditingController _controller,) {
    return Column(
      children: [
        TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return "Enter $_lable";
              }
              else if(_lable=="Phone No." && _controller.text.length != 10){
                return "Enter Valid Phone No.";
              }
              return null;
            },
            controller: _controller,
            keyboardType: _lable=="Phone No." ? TextInputType.number:TextInputType.text,
            decoration: InputDecoration(
              disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              border: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.teal,
                  )),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color:PrimaryColor,
                    width: 2,
                  )),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              labelText: _lable,
              labelStyle: const TextStyle(
                fontSize: 15,
              ),
            ),
            inputFormatters: _lable=="Phone No." ?
            [
              LengthLimitingTextInputFormatter(10),
              FilteringTextInputFormatter.digitsOnly,
            ]:[],
        ),
        const SizedBox(height: 15),
      ],
    );
  }

}
