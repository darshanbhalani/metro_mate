import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metro_mate/OTPVarificationPage.dart';
import 'package:metro_mate/Variables.dart';

class RechargeMetroCardPage extends StatefulWidget {
  const RechargeMetroCardPage({super.key});

  @override
  State<RechargeMetroCardPage> createState() => _RechargeMetroCardPageState();
}

class _RechargeMetroCardPageState extends State<RechargeMetroCardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Metro Cards"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Actions();
                },
                child: Container(
                  height: 180,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20)),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Ahmedabad Metro",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white),
                                ),
                                Text("₹ 0.0",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 20,
                                        color:
                                            Color.fromARGB(255, 255, 215, 0))),
                              ],
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Text("1884 **** **** 147",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[400])),
                            SizedBox(
                              height: 40,
                            ),
                            Text("DARSHAN BHALANI",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[400])),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () {
                  AddCard();
                },
                child: ListTile(
                  leading: Icon(Icons.add_box_outlined),
                  title: Text("Add New Metro Card"),
                  trailing: Icon(Icons.chevron_right),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Actions() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                child: ListTile(
                  leading: Icon(Icons.add),
                  title: Text("Recharge"),
                ),
              ),
              InkWell(
                child: ListTile(
                  leading: Icon(Icons.cancel_outlined),
                  title: Text("Remove"),
                ),
              )
            ],
          ));
        });
  }

  AddCard() {
    TextEditingController controller1 = TextEditingController();
    TextEditingController controller2 = TextEditingController();
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {


          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Box(context, "Card Number", controller1),
                  Box(context, "Registered Phone Number", controller2),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                OTPVarificationPage(phone: controller2.text),
                          ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: PrimaryColor,
                        ),
                        child: Center(
                            child: Text(
                          "Send OTP",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        )),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Box(context, String _lable, TextEditingController _controller) {
    return Column(
      children: [
        TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return "Enter $_lable";
            }
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
          inputFormatters: _lable == "Card Number"
              ? [
                  LengthLimitingTextInputFormatter(12),
                  FilteringTextInputFormatter.digitsOnly,
                ]
              : [
                  LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.digitsOnly,
                ],
        ),
        SizedBox(height: 15),
      ],
    );
  }
}
