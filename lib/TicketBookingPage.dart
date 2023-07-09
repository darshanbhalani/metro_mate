import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:metro_mate/Temp.dart';
import 'package:metro_mate/UPIPaymentPage.dart';
import 'package:metro_mate/Variables.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:random_password_generator/random_password_generator.dart';

class TicketBookingPage extends StatefulWidget {
  const TicketBookingPage({Key? key}) : super(key: key);

  @override
  State<TicketBookingPage> createState() => _TicketBookingPageState();
}

class _TicketBookingPageState extends State<TicketBookingPage> {
  final _controller1 = SingleValueDropDownController();
  final _controller2 = SingleValueDropDownController();
  final _controller3 = SingleValueDropDownController();
  final _formkey = GlobalKey<FormState>();
  String? qrData;
  int x = 0;
  int y = 0;
  int fare = 0;
  int totalFare = 0;
  bool flag = false;
  String bookingTime = "";
  String bookingDate = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PrimaryColor,
        title: const Text("Ticket Booking"),
      ),
      body: Form(
        key: _formkey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropField(
                  context, "Number of Tickets", Numbers, _controller1, true),
              DropField(context, "Source", Stations, _controller2, true),
              DropField(context, "Destination", Stations, _controller3, true),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Price of Single Ticket :- $fare"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Total Payable Amount :- $totalFare"),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: InkWell(
        onTap: () async {
          if (_formkey.currentState!.validate()) {
            if (_controller2.dropDownValue!.value !=
              _controller3.dropDownValue!.value) {
                  final RandomPasswordGenerator randomPassword = RandomPasswordGenerator();
                  String transactionId = randomPassword.randomPassword(
                    passwordLength: 20,
                    specialChar: false,
                    letters: true,
                    numbers: true,
                    uppercase: true,
                  );
                bookingDate =
                    "${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}";
                bookingTime =
                    "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
                qrData =
                    "Ahemdabad-${transactionId}-${_controller2.dropDownValue!.value}-${_controller3.dropDownValue!.value}-$bookingTime-$bookingDate-$fare";
                  setState(() {});
                  await PaymentMethods();
            }else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Source and Destination both are Same !"),
              ));
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
            child: Center(
                child: Text("Pay ₹ $totalFare",
                    style: const TextStyle(fontSize: 20, color: Colors.white))),
          ),
        ),
      ),
    );
  }

  Calculate() {
    if (_controller1.dropDownValue!.value != null &&
        _controller2.dropDownValue!.value != null &&
        _controller3.dropDownValue!.value != null) {
      if (_controller2.dropDownValue!.value !=
          _controller3.dropDownValue!.value) {
        Loading(context);
        for (int i = 0; i < Price[0].length; i++) {
          if (Price[0][i] == _controller2.dropDownValue!.value) {
            x = i;
            break;
          }
        }
        for (int i = 0; i < Price[0].length; i++) {
          if (Price[i][0] == _controller3.dropDownValue!.value) {
            y = i;
            break;
          }
        }
        fare = int.parse(Price[x][y]);
        totalFare = fare * (_controller1.dropDownValue!.value as int);
        setState(() {
          flag = true;
        });
        Navigator.pop(context);
      } else {
        fare = 0;
        totalFare = 0;
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Source and Destination both are Same !"),
        ));
      }
    }
  }

  DropField(context, String lable, List<DropDownValueModel> items,
      SingleValueDropDownController controller, bool condition) {
    return Column(
      children: [
        DropDownTextField(
          isEnabled: condition,
          clearOption: false,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select an option';
            }
            return null;
          },
          onChanged: (value) async {
            await Calculate();
          },
          controller: controller,
          dropDownItemCount: 5,
          dropDownList: items,
          dropdownRadius: 0,
          textFieldDecoration: InputDecoration(
            labelText: lable,
            disabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: PrimaryColor,
              ),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
              ),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  ticketView(data, bookingTime, bookingDate, totalFare) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Ahemdabad Metro"),
                QrImageView(
                  data: qrData.toString(),
                  version: QrVersions.auto,
                  size: 250,
                ),
                Text(
                    '${_controller2.dropDownValue!.value} to ${_controller3.dropDownValue!.value}'),
                Text("Booking Date :- $bookingDate"),
                Text("Booking Time :- $bookingTime"),
                Text("Total Fare :- $totalFare")
              ],
            ),
            actions: [
              TextButton(onPressed: () {}, child: const Text("Download")),
              TextButton(onPressed: () {}, child: const Text("Share")),
            ],
          );
        });
  }

  PaymentMethods(){
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Payment Options",style: TextStyle(fontWeight: FontWeight.bold,color: PrimaryColor,fontSize: 25),)
                      ],
                    ),
                    SizedBox(height: 10,),
                    Box("Source", _controller2.dropDownValue!.value),
                    Box("Destination", _controller3.dropDownValue!.value),
                    Box("Number of Tickets", _controller1.dropDownValue!.value.toString()),
                    Box("Fare of Single Ticket", fare.toString()),
                    Box("Total Payable Amount", totalFare.toString()),
                    InkWell(
                      onTap: (){
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: PrimaryColor
                          )
                        ),
                        child: ListTile(
                          title: Text("Pay by Wallet"),
                          trailing: Icon(Icons.chevron_right),
                        ),
                      ),
                    ),
                    SizedBox(height: 8,),
                    InkWell(
                      onTap: (){
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: PrimaryColor
                            )
                        ),
                        child: ListTile(
                          title: Text("Pay by Cradit/Debit Card"),
                          trailing: Icon(Icons.chevron_right),
                        ),
                      ),
                    ),
                    SizedBox(height: 8,),
                    InkWell(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UPIPaymentPage(amount: totalFare.toString()),
                            ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: PrimaryColor
                            )
                        ),
                        child: ListTile(
                          title: Text("Pay by UPI"),
                          trailing: Icon(Icons.chevron_right),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
  }

  Box(String _lable,String _value){
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 15),
              children: <TextSpan>[
                TextSpan(text: _lable+" :- ", style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: _value),
              ],
            ),
          ),
          SizedBox(height: 6,),
        ],
      ),
    );
  }
}
