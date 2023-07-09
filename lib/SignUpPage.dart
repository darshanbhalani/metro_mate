import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metro_mate/OTPVarificationPage.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Box(context, "First Name", controller1),
              Box(context, "Last Name", controller1),
              Box(context, "Phone No.", controller1),
            ],
          ),
        ),
      ),
      bottomSheet: InkWell(
        onTap: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OTPVarificationPage(phone: controller3.text.toString()),
              ));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: PrimaryColor,
            ),
            child: Center(child: Text("Submit",style: TextStyle(fontSize:20,color: Colors.white),)),
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
              return null;
            },
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.teal,
                  )),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  )),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              labelText: _lable,
              labelStyle: TextStyle(
                fontSize: 15,
              ),
            ),
            inputFormatters: _lable=="Phone No." ?
            [
              LengthLimitingTextInputFormatter(10),
              FilteringTextInputFormatter.digitsOnly,
            ]:[],
            onChanged: (value) {
              if (value.length == 10) {
                FocusScope.of(context).nextFocus();
              }
            }),
        SizedBox(height: 15),
      ],
    );
  }

}
