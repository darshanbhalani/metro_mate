
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metro_mate/Variables.dart';

class RechargeMetroCardPage extends StatefulWidget {
  const RechargeMetroCardPage({super.key});

  @override
  State<RechargeMetroCardPage> createState() => _RechargeMetroCardPageState();
}

class _RechargeMetroCardPageState extends State<RechargeMetroCardPage> {
  List data = [];

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    getData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: PrimaryColor,
          title: const Text("Metro Cards"),
          actions: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    onPressed: () async {
                      // getData();
                      // print(cardList);
                      // AddCard();
                    },
                    icon: const Icon(Icons.add_box_outlined)))
          ],
        ),
        body: data.isEmpty
            ? const Center(
                child: Text("Oops !! No Card Linked"),
              )
            : FutureBuilder(
                future: getData(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    itemCount: data.length,
                      itemBuilder: (snapshot,index) {
                    String cNo="XXXX XXXX XXXX XXXX";
                    // String pNo;
                    var fName="XXXXXXXX";
                    var lName="XXXXXXXX";
                    var metro="XXXXXXXX XXXXXXXX";
                    var balance="0.0";

                    cNo=data[0][0];
                      // pNo=value["Phone No"];
                      fName=data[0][2];
                      lName=data[0][3];
                      balance=data[0][1];
                      metro=data[0][4];

                    return GestureDetector(
                      onTap: () {
                        Actions();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
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
                                          metro,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.white),
                                        ),
                                        Text("₹ $balance",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w900,
                                                fontSize: 20,
                                                color:
                                                Color.fromARGB(255, 255, 215, 0))),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 40,
                                    ),
                                    Text(cNo,
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[400])),
                                    const SizedBox(
                                      height: 40,
                                    ),
                                    Text("$fName $lName",
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
                    );
                  });
                }));
  }

  Future getData() async {
    for (String card in cardList) {
      data=[];
      await fire.collection("Cards").doc("1234123412341234").get().then((value) {
        List temp = [];
        temp.add(value["Card No"]);
        temp.add(value["Balance"]);
        temp.add(value["First Name"]);
        temp.add(value["Last Name"]);
        temp.add(value["Metro"]);
        temp.add(value["Phone No"]);
        data.add(temp);
      });
    }
    setState(() {
    });
  }

  Actions() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                child: ListTile(
                  leading: Icon(Icons.add),
                  title: Text("Recharge"),
                ),
              ),
              GestureDetector(
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
    final GlobalKey<FormState> key = GlobalKey<FormState>();

    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Form(
                key: key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Box(context, "Card Number", controller1),
                    Box(context, "Phone Number", controller2),
                    GestureDetector(
                      onTap: () async {
                        Loading(context);
                        if (key.currentState!.validate()) {
                          var snapShot = await fire
                              .collection("Cards")
                              .doc(controller1.text)
                              .get();
                          if (snapShot.exists) {
                            await fire
                                .collection("Cards")
                                .doc(controller1.text)
                                .get()
                                .then((value) {
                              if (value["Phone No"] == controller2.text) {
                                // SendOTP(context, controller2.text);
                                cardList.add(value["Card No"]);
                                Navigator.pop(context);
                                setState(() {});
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content:
                                      Text("UnValid Card No. of Phone No."),
                                ));
                              }
                            });
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Text("UnValid Card No. of Phone No."),
                            ));
                          }
                        }
                        Navigator.pop(context);
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
                          child: const Center(
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
            ),
          );
        });
  }

  Box(context, String lable, TextEditingController controller) {
    return Column(
      children: [
        TextFormField(
          cursorColor: Colors.black,
          controller: controller,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (lable == "Phone Number" && controller.text.length != 10) {
              return "Please Enter Valid $lable";
            } else if (lable == "Card Number" && controller.text.length != 16) {
              return "Please Enter Valid $lable";
            }
            return null;
          },
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
              color: PrimaryColor,
              width: 2,
            )),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            labelText: lable,
            labelStyle: const TextStyle(fontSize: 16, color: Colors.black),
          ),
          inputFormatters: lable == "Phone Number"
              ? [
                  LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.digitsOnly,
                ]
              : [
                  LengthLimitingTextInputFormatter(16),
                  FilteringTextInputFormatter.digitsOnly,
                ],
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
