import 'dart:ui' as ui;
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:metro_mate/MainScreen/Home/TicketBooking/TicketViewPage.dart';
import 'package:metro_mate/MainScreen/Home/TicketBooking/UPIPaymentPage.dart';
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
  final _imgkey = GlobalKey<FormState>();
  String? qrData;
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
              DropField(context, "Source", metroStationsList, _controller2, true),
              DropField(context, "Destination", metroStationsList, _controller3, true),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("fareMatrix of Single Ticket :- $fare"),
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
          Loading(context);
          if (_formkey.currentState!.validate()) {
            if (_controller2.dropDownValue!.value !=
                _controller3.dropDownValue!.value) {
              final RandomPasswordGenerator random =
                  RandomPasswordGenerator();
              String randomId = random.randomPassword(
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
              String bookingId="$randomId${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}";
              qrData =
                  "Ahemdabad-$bookingId-${_controller2.dropDownValue!.value}-${_controller3.dropDownValue!.value}-$bookingTime-$bookingDate-$fare";
              setState(() {
                // await PaymentMethods();
                // ticketView(qrData, bookingTime, bookingDate, totalFare,_controller1.dropDownValue!.value.toString(),bookingId);
              });
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TicketViewPage(city:selectedCity,phone:cuPhone,qrData: qrData!, source: _controller2.dropDownValue!.value, destination: _controller3.dropDownValue!.value, bookingTime: bookingTime, bookingDate: bookingDate, numberOfTickets: _controller1.dropDownValue!.value.toString(), totalFare: totalFare.toString(),bookingId: bookingId,),
                  ));
            } else {
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
                child: !flag ? const Text("Next",
                    style: TextStyle(fontSize: 20, color: Colors.white)):Text("Pay ₹ $totalFare",
                    style: const TextStyle(fontSize: 20, color: Colors.white))),
          ),
        ),
      ),
    );
  }

  Calculate() async{
    int? x;
    int? y;
    if (_controller1.dropDownValue!.value != null &&
        _controller2.dropDownValue!.value != null &&
        _controller3.dropDownValue!.value != null) {
      if (_controller2.dropDownValue!.value !=
          _controller3.dropDownValue!.value) {
        Loading(context);
        final snapshot1 =
        await ref.ref("Fare/$selectedCity/locations").orderByKey().get();
        List<dynamic> values1 = snapshot1.value as List<dynamic>;
        List<Object> list1 = List<Object>.from(values1);
        final snapshot2 =
        await ref.ref("Fare/$selectedCity/distances").orderByKey().get();
        List<dynamic> values2 = snapshot2.value as List<dynamic>;
        List<Object> list2 = List<Object>.from(values2);
        fareMatrix.add(list1);
        for (var x in list2) {
          fareMatrix.add(x);
        }
        for (int i = 0; i < fareMatrix[0].length; i++) {
          if (fareMatrix[0][i] == _controller2.dropDownValue!.value.toString()) {
            x = i;
            break;
          }
        }
        for (int i = 0; i < fareMatrix.length; i++) {
          if (fareMatrix[i][0] == _controller3.dropDownValue!.value) {
            y = i;
            break;
          }
        }
        fare = int.parse(fareMatrix[x!][y!]);
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

  ticketView(data, bookingTime, bookingDate, totalFare,number,id) async{
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            content: RepaintBoundary(
              key: _imgkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Ahemdabad Metro",style: TextStyle(fontWeight: FontWeight.bold),),
                  QrImageView(
                    data: qrData.toString(),
                    version: QrVersions.auto,
                    size: 250,
                  ),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black, fontSize: 36),
                      children: <TextSpan>[
                        TextSpan(text: '${_controller2.dropDownValue!.value} ', style: const TextStyle(fontWeight: FontWeight.bold)),
                        const TextSpan(text: 'to '),
                        TextSpan(text: _controller3.dropDownValue!.value, style: const TextStyle(fontWeight: FontWeight.bold))
                      ],
                    ),
                    textScaleFactor: 0.5,
                  ),
                  const SizedBox(height: 5,),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black, fontSize: 36),
                      children: <TextSpan>[
                        const TextSpan(text: 'Booking Date :- ', style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: bookingDate),
                      ],
                    ),
                    textScaleFactor: 0.5,
                  ),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black, fontSize: 36),
                      children: <TextSpan>[
                        const TextSpan(text: 'Booking Time :- ', style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: bookingTime),
                      ],
                    ),
                    textScaleFactor: 0.5,
                  ),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black, fontSize: 36),
                      children: <TextSpan>[
                        const TextSpan(text: 'Number of Tickets :- ', style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: "$number"),
                      ],
                    ),
                    textScaleFactor: 0.5,
                  ),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black, fontSize: 36),
                      children: <TextSpan>[
                        const TextSpan(text: 'Total Fare ', style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: "$totalFare"),
                      ],
                    ),
                    textScaleFactor: 0.5,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () async{
                RenderRepaintBoundary? boundary = _imgkey.currentContext!.findRenderObject() as RenderRepaintBoundary?;
                ui.Image image = await boundary!.toImage();
                ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
                Uint8List pngBytes = byteData!.buffer.asUint8List();
                final storageRef = FirebaseStorage.instance.ref().child(
                    'Ticket/Ahmedabad/$id');

                storageRef.putData(pngBytes).whenComplete(() async {
                  final ticketUrl = await FirebaseStorage.instance
                      .ref()
                      .child(
                      'Ticket/Ahmedabad/$id')
                      .getDownloadURL();
                  print("TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT");
                  print(ticketUrl);
                });
                return showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Container(
                          height: 250,
                          width: 250,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(pngBytes)
                            )
                          ),
                        ),
                      );
                    });
                }, child: const Text("Download")),
              TextButton(onPressed: () {}, child: const Text("Share")),
            ],
          );
        });
  }

  PaymentMethods() {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Payment Options",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: PrimaryColor,
                            fontSize: 25),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Box("Source", _controller2.dropDownValue!.value),
                  Box("Destination", _controller3.dropDownValue!.value),
                  Box("Number of Tickets",
                      _controller1.dropDownValue!.value.toString()),
                  Box("Fare of Single Ticket", fare.toString()),
                  Box("Total Payable Amount", totalFare.toString()),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: PrimaryColor)),
                      child: const ListTile(
                        title: Text("Pay by Wallet"),
                        trailing: Icon(Icons.chevron_right),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: PrimaryColor)),
                      child: const ListTile(
                        title: Text("Pay by Cradit/Debit Card"),
                        trailing: Icon(Icons.chevron_right),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                UPIPaymentPage(amount: totalFare.toString()),
                          ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: PrimaryColor)),
                      child: const ListTile(
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

  Box(String lable, String value) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black, fontSize: 15),
              children: <TextSpan>[
                TextSpan(
                    text: "$lable :- ",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: value),
              ],
            ),
          ),
          const SizedBox(
            height: 6,
          ),
        ],
      ),
    );
  }

}
