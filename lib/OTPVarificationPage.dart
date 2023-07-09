import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metro_mate/HomePage.dart';
import 'package:metro_mate/SelectCityPage.dart';
import 'package:metro_mate/Variables.dart';

class OTPVarificationPage extends StatefulWidget {
  final String phone;
  const OTPVarificationPage({Key? key,required this.phone}) : super(key: key);

  @override
  State<OTPVarificationPage> createState() => _OTPVarificationPageState();
}

class _OTPVarificationPageState extends State<OTPVarificationPage> {

  TextEditingController controller1 =TextEditingController();
  TextEditingController controller2 =TextEditingController();
  TextEditingController controller3 =TextEditingController();
  TextEditingController controller4 =TextEditingController();
  TextEditingController controller5 =TextEditingController();
  TextEditingController controller6 =TextEditingController();
  String _hintText = "0";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children:[
          Positioned(
            top: -200,
            left: -200,
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
            top: (MediaQuery.of(context).size.height/2)+80,
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
            top: (MediaQuery.of(context).size.height/2)-80,
            right: -100,
            child: Container(
              height: 200,
              width: 200,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(75, 255, 114, 94),
                  shape: BoxShape.circle
              ),
            ),
          ),
          Form(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.chevron_left,size: 35,))
                  ],
                ),
                SizedBox(height: 30,),
                Text("OTP Varification",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                SizedBox(height: 30,),
                Text("OTP sended to Mobile No. +91 ${widget.phone}"),
                SizedBox(height: 30,),
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
                SizedBox(height: 10,),
                InkWell(
                    onTap: (){
                      //   Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => HomePage(),
                      //       ));
                    },
                    child: Text("Resend OTP",style: TextStyle(color: PrimaryColor,fontSize: 15),))
              ],
            ),
          ),
        ]
      ),
      bottomSheet: InkWell(
        onTap: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SelectCityPage(currentCity: selectedCity),
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
  Box(context,TextEditingController _controller){
    return SizedBox(
      height: 48,
      width: 48,
      child: Center(
        child: TextFormField(
          controller: _controller,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly,
          ],
          cursorColor: Color.fromARGB(255, 255, 114, 94),
          decoration: InputDecoration(
            hintText: _hintText,
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.teal,
                )),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 255, 114, 94),
                  width: 2,
                )),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            labelStyle: TextStyle(
              fontSize: 15,
            ),
          ),
          onChanged: (value){
            if(value.length==1){
              FocusScope.of(context).nextFocus();
            }
            else{
              FocusScope.of(context).previousFocus();
            }
          },
          onTap: (){
            setState(() {
              _hintText="";
            });
          },
          onSaved: (pin1){},
        ),
      ),
    );
  }
}

