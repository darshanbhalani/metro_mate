import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        title: const Text("Metro Cards"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: (){
                  AddCard();
                },
                icon: const Icon(Icons.add_box_outlined)
            )
          )
        ],
      ),
      body:cardList.isEmpty ? const Center(child: Text("Oops !! No Card Linked"),):ListView.builder(
        itemCount: cardList.length,
        itemBuilder: (BuildContext context, int index) {
          String cNo="XXXX XXXX XXXX XXXX";
          // String pNo;
          String fName="XXXXXXXX";
          String lName="XXXXXXXX";
          String metro="XXXXXXXX XXXXXXXX";
          double balance=0.0;
          fire.collection("Cards").doc(cardList[index].toString()).get().then((value) {
             cNo=value["Card No"];
             // pNo=value["Phone No"];
             fName=value["First Name"];
             lName=value["Last Name"];
             balance=value["Balance"];
             metro=value["Metro"];
             setState(() {
             });
           });
          return InkWell(
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
                          Text(fName + " " + lName,
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
        }),
    );
  }

  Actions() {
    return showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
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
    final GlobalKey<FormState> _key = GlobalKey<FormState>();

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
                key: _key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Box(context, "Card Number", controller1),
                    Box(context, "Registered Phone Number", controller2),
                    InkWell(
                      onTap: () async {
                        Loading(context);
                        if(_key.currentState!.validate()){
                          var snapShot = await fire.collection("Cards").doc(controller1.text).get();
                          if(snapShot.exists){
                           await fire.collection("Cards").doc(controller1.text).get().then((value) {
                              if(value["Phone No"] == controller2.text){
                                // SendOTP(context, controller2.text);
                                cardList.add(value["Card No"]);
                                Navigator.pop(context);
                                setState(() {
                                });
                              }else{
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text("UnValid Card No. of Phone No."),
                                ));
                              }
                            });
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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
          validator: (value) {
            if (value!.isEmpty) {
              return "Enter $lable";
            }
            return null;
          },
          controller: controller,
          keyboardType: TextInputType.number,
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
              color: Theme.of(context).primaryColor,
              width: 2,
            )),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            labelText: lable,
            labelStyle: const TextStyle(
              fontSize: 15,
            ),
          ),
          inputFormatters: lable == "Card Number"
              ? [
                  LengthLimitingTextInputFormatter(12),
                  FilteringTextInputFormatter.digitsOnly,
                ]
              : [
                  LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.digitsOnly,
                ],
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}

// return InkWell(
// onTap: () {
// Actions();
// },
// child: Padding(
// padding: const EdgeInsets.all(8.0),
// child: Container(
// height: 180,
// width: MediaQuery.of(context).size.width,
// decoration: BoxDecoration(
// color: Colors.black,
// borderRadius: BorderRadius.circular(20)),
// child: Stack(
// children: [
// Padding(
// padding: const EdgeInsets.symmetric(
// horizontal: 12, vertical: 8),
// child: Column(
// mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Text(
// metro,
// style: const TextStyle(
// fontSize: 15,
// fontWeight: FontWeight.w300,
// color: Colors.white),
// ),
// Text("₹ $balance",
// style: const TextStyle(
// fontWeight: FontWeight.w900,
// fontSize: 20,
// color:
// Color.fromARGB(255, 255, 215, 0))),
// ],
// ),
// const SizedBox(
// height: 40,
// ),
// Text(cNo,
// style: TextStyle(
// fontSize: 25,
// fontWeight: FontWeight.bold,
// color: Colors.grey[400])),
// const SizedBox(
// height: 40,
// ),
// Text(fName + " " + lName,
// style: TextStyle(
// fontSize: 20,
// fontWeight: FontWeight.w500,
// color: Colors.grey[400])),
// ],
// ),
// ),
// ],
// ),
// ),
// ),
// );