import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metro_mate/Variables.dart';

class OTPVarificationPage extends StatefulWidget {
  final String phone;
  final String lable;
  final String verificationId;
  const OTPVarificationPage(
      {Key? key, required this.phone, required this.verificationId,required this.lable})
      : super(key: key);

  @override
  State<OTPVarificationPage> createState() => _OTPVarificationPageState();
}

class _OTPVarificationPageState extends State<OTPVarificationPage> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  TextEditingController controller4 = TextEditingController();
  TextEditingController controller5 = TextEditingController();
  TextEditingController controller6 = TextEditingController();
  String cvId="";
  String _hintText = "0";
  var code = "";

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    controller4.dispose();
    controller5.dispose();
    controller6.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    cvId=widget.verificationId;
    return Scaffold(
      body: Form(
        key: _key,
        child: Stack(children: [
          Positioned(
            top: -200,
            left: -200,
            child: Container(
              height: 400,
              width: 400,
              decoration:BoxDecoration(
                  color: SecondryColor,
                  shape: BoxShape.circle),
            ),
          ),
          Positioned(
            top: (MediaQuery.of(context).size.height / 2) + 80,
            left: -75,
            child: Container(
              height: 150,
              width: 150,
              decoration:BoxDecoration(
                  color: SecondryColor,
                  shape: BoxShape.circle),
            ),
          ),
          Positioned(
            top: (MediaQuery.of(context).size.height / 2) - 80,
            right: -100,
            child: Container(
              height: 200,
              width: 200,
              decoration:BoxDecoration(
                  color: SecondryColor,
                  shape: BoxShape.circle),
            ),
          ),
          Form(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.chevron_left,
                          size: 35,
                        ))
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "OTP Verification",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text("OTP sended to Mobile No. ${widget.phone}"),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Box(context, controller1),
                    Box(context, controller2),
                    Box(context, controller3),
                    Box(context, controller4),
                    Box(context, controller5),
                    Box(context, controller6),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                    onTap: () async {
                      Loading(context);
                      try{
                        await auth
                            .verifyPhoneNumber(
                          phoneNumber: widget.phone,
                          codeSent: (String verificationId, int? resendToken) async {
                            cvId = verificationId;
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text("OTP Sended"),
                            ));
                          },
                          verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {},
                          codeAutoRetrievalTimeout: (String verificationId) {
                          },
                          verificationFailed: (FirebaseAuthException error) {},
                        );
                      } catch(e){
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Oops! Somthing went wrong please try again later"),
                        ));
                      }
                    },
                    child: Text(
                      "Resend OTP",
                      style: TextStyle(color: PrimaryColor, fontSize: 15),
                    ))
              ],
            ),
          ),
        ]),
      ),
      bottomSheet: Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: GestureDetector(
            onTap: () async {
              verifyOTP(
                  context,cvId=="" ? widget.verificationId:cvId, code,widget.phone,widget.lable);
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: PrimaryColor,
              ),
              child:const Center(
                  child: Text(
                    "Verify OTP",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )),
            ),
          ),
        ),
      ),
    );

  }

  Box(context, TextEditingController controller) {
    return SizedBox(
      height: 48,
      width: 48,
      child: Center(
        child: TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly,
          ],
          cursorColor: BorderColor,
          decoration: InputDecoration(
            hintText: _hintText,
            disabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            border: const OutlineInputBorder(
                borderSide: BorderSide(
              color: Colors.teal,
            )),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
              color: BorderColor,
              width: 2,
            )),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            labelStyle: const TextStyle(
              fontSize: 15,
            ),
          ),
          onChanged: (value) {
            code = controller1.text.toString() +
                controller2.text.toString() +
                controller3.text.toString() +
                controller4.text.toString() +
                controller5.text.toString() +
                controller6.text.toString();
            if (value.isNotEmpty) {
              FocusScope.of(context).nextFocus();
            } else {
              FocusScope.of(context).previousFocus();
            }
          },
          onTap: () {
            setState(() {
              _hintText = "";
            });
          },
        ),
      ),
    );
  }
}
