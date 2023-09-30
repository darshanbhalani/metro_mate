import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metro_mate/Variables.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {

  TextEditingController controller = TextEditingController(text: "0.0");
  late Razorpay _razorpay;

  @override
  void initState() {
    fatchCurrntBalance();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  @override
  void dispose(){
    _razorpay.clear();
    super.dispose();
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    if(balance==null){
      balance=double.parse(controller.text);
    }else{
      balance=balance!+double.parse(controller.text);
    }
    await fire.collection('Users').doc(cuPhone).update(
        {
          'Photo': (cureentBalance! + double.parse(controller.text)).toString()
        });
    fatchCurrntBalance();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
          "Amount Successfully added into your wallet"),
    ));
    controller.value=(0.0).toString() as TextEditingValue;
    setState(() {
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
  }

  Future<void> _handleExternalWallet(ExternalWalletResponse response) async {
  }

  double? cureentBalance;


  fatchCurrntBalance(){
    fire.collection('Users').doc(cuPhone).get().then((value) {
      cureentBalance=double.parse(value["Photo"]);
    }).whenComplete(() async{
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString("cuPhoto", cureentBalance.toString());
      setState(() {
      });
    });
  }

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
                   Text("₹ ${cureentBalance ?? 0.0}",
                      style:
                          const TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
                  const SizedBox(
                    height: 25,
                  ),
                  GestureDetector(
                    onTap: () async {
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
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text("Note : Our high-speed wallet feature in the metro ticket booking app ensures lightning-fast transactions. Easily preload funds for instant ticket purchases, allowing commuters to skip the lines and board the metro with a simple tap, making urban travel faster and more convenient than ever.",textAlign: TextAlign.center,),
                  ),
                  SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){},
                    child: ListTile(
                      tileColor: BGColor,
                      title: Text("Show Transaction History"),
                      trailing: Icon(Icons.chevron_right),
                    ),
                  )
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
          final formkey = GlobalKey<FormState>();
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Add Amount",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                  const SizedBox(height: 10,),
                  Form(
                    key: formkey,
                    child:
                    TFormField(context, "Amount", controller, true, false),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        PriceBox("50"),
                        PriceBox("100"),
                        PriceBox("150"),
                        PriceBox("200"),
                        PriceBox("250"),
                        PriceBox("500"),
                        PriceBox("600"),
                        PriceBox("800"),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // const Text("Maximum Wallet Capacity is ₹ 1000.",textAlign: TextAlign.center),
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
                          // if(formkey.currentState!.validate()){}
                          Navigator.pop(context);
                          // balance=balance+double.parse(controller.text);
                          setState(() {
                          });
                          fatchCurrntBalance();
                          await RazorpayMethod();
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: PrimaryColor,
                          ),
                          child:Center(
                              child: Text("Add",
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

  PriceBox(lable) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: () {
          controller.text = double.parse(lable).toString();
          setState(() {
          });
          // if((balance+double.parse(lable)).toDouble() <= 1000.00){
          //   controller.text = double.parse(lable).toString();
          //   setState(() {});
          // }
          // else{
          //   ScaffoldMessenger.of(context)
          //       .showSnackBar(const SnackBar(
          //     behavior: SnackBarBehavior.floating,
          //     content: Text("Oops! You Can't add more than ₹ 1000 in wallet."),
          //   ));
          // }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: BGColor,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              "₹ $lable",
              style:TextStyle(color: PrimaryColor),
            ),
          ),
        ),
      ),
    );
  }

  RazorpayMethod(){
    var options = {
      'key': 'rzp_test_864jf5OoKDSQuT',
      'amount': (double.parse(controller.text)*100).toString(), //in the smallest currency sub-unit.
      'name': 'Metro Mate.',
      'currency':'INR',
      'description': 'Add Money in Wallet',
      'timeout': 120, // in seconds
      'prefill': {
        'contact': '$cuPhone',
        'email': '${cuFName}${cuLName}@gmail.com'
      },

    };
    _razorpay.open(options);
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
          onChanged: (value){
            setState(() {});
          },
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
