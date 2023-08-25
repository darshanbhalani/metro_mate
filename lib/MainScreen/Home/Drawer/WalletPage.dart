import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metro_mate/Variables.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  double balance = 850;
  TextEditingController controller = TextEditingController(text: "0.0");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PrimaryColor,
        title: const Text("My Wallet"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              Column(
                children: [
                  const Text(
                    "Total Balance",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                  ),
                   Text("₹ ${balance}",
                      style:
                          const TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
                  const SizedBox(
                    height: 25,
                  ),
                  GestureDetector(
                    onTap: () {
                      addCash();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: PrimaryColor,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        child: Text(
                          "Add Cash",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  addCash() {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          final _formkey = GlobalKey<FormState>();
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Add Amount",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),
                  Form(
                    key: _formkey,
                    child: TFormField(context, "Amount", controller, true, false),),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        PriceBox(context,"50"),
                        PriceBox(context,"100"),
                        PriceBox(context,"150"),
                        PriceBox(context,"200"),
                        PriceBox(context,"250"),
                        PriceBox(context,"500"),
                        PriceBox(context,"600"),
                        PriceBox(context,"800"),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("Maximum Wallet Capacity is ₹ 1000.",textAlign: TextAlign.center),
                  const Text(
                    "Note : Once you add money in your wallet it can't be revice.",
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    alignment: Alignment.center,
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: GestureDetector(
                        onTap: () async {
                          if(_formkey.currentState!.validate()){}
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: PrimaryColor,
                          ),
                          child:Center(
                              child: Text("Add ₹ ${controller.text}",
                                style: const TextStyle(fontSize: 20, color: Colors.white),
                              )),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  PriceBox(context,lable) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: () {
          print((balance-double.parse(lable)).runtimeType);
          if((balance+double.parse(lable)).toDouble() <= 1000.00){
            controller.text = double.parse(lable).toString();
            setState(() {});
          }
          else{
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text("Oops! You Can't add more than ₹ 1000 in wallet."),
            ));
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: PrimaryColor,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              "₹ ${lable}",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  TFormField(context, String lable, TextEditingController controller,
      bool condition, bool flag) {
    return Column(
      children: [
        TextFormField(
          cursorColor: Colors.black,
          controller: controller,
          obscureText: flag,
          enabled: condition,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty || value == 0.0) {
              return 'Please Enter Amount';
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
            focusedErrorBorder: OutlineInputBorder(
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
          inputFormatters: [
            LengthLimitingTextInputFormatter(3),
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
