import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metro_mate/LogIn/OTPVarificationPage.dart';
import 'package:metro_mate/MainScreen/Home/Drawer/SelectCityPage.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore fire = FirebaseFirestore.instance;
FirebaseDatabase ref = FirebaseDatabase.instance;

Color PrimaryColor = const Color.fromARGB(255, 51,149,214);
Color SecondryColor = const Color.fromARGB(115, 128, 189, 230);
Color BorderColor = const Color.fromARGB(255, 128, 189, 230);
Color BGColor = const Color.fromARGB(100, 204, 228, 245);

String selectedCity = "";
String cuFName = "";
String cuLName = "";
String cuPhone = "";
String cuPhoto = "";
double? balance;
List metroData = [];
List cardList = [];
List<DropDownValueModel> metroStationsList = [];
Map<String, Set<String>> metroGraph = {};
List stationList = [];
List fareMatrix = [];
Map<String, Color> stationLineColor = {};

ShowField(String lable, String value, bool flag) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(lable,
          style: const TextStyle(
            fontSize: 15,
          )),
      const SizedBox(
        height: 5,
      ),
      TextFormField(
        enabled: flag,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.teal,
          )),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.orange,
            width: 3,
          )),
          labelText: value,
          labelStyle:
              const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          hintStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
      const SizedBox(
        height: 20,
      ),
    ],
  );
}

List<DropDownValueModel> Numbers = [
  const DropDownValueModel(name: "1", value: 1),
  const DropDownValueModel(name: "2", value: 2),
  const DropDownValueModel(name: "3", value: 3),
  const DropDownValueModel(name: "4", value: 4),
  const DropDownValueModel(name: "5", value: 5),
  const DropDownValueModel(name: "6", value: 6),
];

TFormField(context, String lable, TextEditingController controller,
    bool condition, bool flag) {
  return Column(
    children: [
      TextFormField(
        cursorColor: Colors.black,
        controller: controller,
        obscureText: flag,
        enabled: condition,
        keyboardType:
            lable == "Phone No." ? TextInputType.number : TextInputType.text,
        validator: (value) {
          if (lable == "Phone No." && controller.text.length != 10) {
            return "Please Enter Valid $lable";
          } else if (controller.text.isEmpty) {
            return "Please Enter $lable";
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
            color: BorderColor,
            width: 2,
          )),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
            color: BorderColor,
            width: 2,
          )),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          labelText: lable,
          labelStyle: const TextStyle(fontSize: 16, color: Colors.black),
        ),
        inputFormatters: lable == "Phone No."
            ? [
                LengthLimitingTextInputFormatter(10),
                FilteringTextInputFormatter.digitsOnly,
              ]
            : [],
      ),
      const SizedBox(height: 15),
    ],
  );
}

Loading(context) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        // return Center(child: CircularProgressIndicator(color: PrimaryColor));
        return (Center(
            child: Container(
              height: 100,
                width: 100,
                child: RiveAnimation.asset('assets/animations/Loading.riv'))));
      });
}

List Cities = [
  "Ahmedabad",
  "Agra",
  "Bengaluru",
  "Bhopal",
  "Chennai",
  "Delhi",
  "Hyderabad",
  "Jaipur",
  "Kanpur",
  "Kochi",
  "Kolkata",
  "Lucknow",
  "Mumbai",
  "Nagpur",
  "Noida",
  "Pune"
];

SendOTP(context, String pnone, bool flag, String lable) async {
  try {
    await auth.verifyPhoneNumber(
      phoneNumber: '+91 $pnone',
      codeSent: (String verificationId, int? resendToken) async {
        verificationId = verificationId;
        Navigator.pop(context);
        if (flag) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OTPVarificationPage(
                    lable: lable,
                    phone: '+91 $pnone',
                    verificationId: verificationId),
              ));
        }
      },
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {},
      codeAutoRetrievalTimeout: (String verificationId) {
        // Navigator.pop(context);
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //   content: Text(
        //       "Oops! Your phone Number is blocked because of suspicious activity try again after 24 hours."),
        // ));
      },
      verificationFailed: (FirebaseAuthException error) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              "Oops! Your phone Number is blocked because of suspicious activity try again after 24 hours."),
        ));
      },
    );
  } on FirebaseException catch (e) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(e.code),
    ));
  }
}

verifyOTP(context, verificationId, String code, String phone, lable) async {
  Loading(context);
  try {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: code);
    UserCredential userCredential = await auth.signInWithCredential(credential);
    if (userCredential.user != null) {
      await getUserData(phone);
      if (lable == "login") {
        await getUserData(phone);
      } else if (lable == "signup") {
        await signUp(cuFName, cuLName, phone);
      }
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SelectCityPage(currentCity: ""),
          ));
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Oops! Somthing went wrong please try again later"),
      ));
    }
  } on FirebaseException catch (e) {
    Navigator.pop(context);
    if (e.code == "invalid-verification-code") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Oops! Wrong OTP"),
      ));
    } else if (e.code == "session-expired") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Oops! OTP timed out please resend OTP"),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${e.message}"),
      ));
    }
  }
}

Future signUp(String fname, String lname, String phone) async {
  phone = phone.replaceAll("+91 ", "");
  fire.collection("Users").doc(phone).set({
    "First Name": fname.toUpperCase(),
    "Last Name": lname.toUpperCase(),
    "Phone No": phone,
    "Photo": 0.0
  });
}

Temp() {}

Future getUserData(String phone) async {
  phone = phone.replaceAll("+91", "").replaceAll(" ", "");
  fire.collection("Users").doc(phone).get().then((value) {
    cuFName = value["First Name"];
    cuLName = value["Last Name"];
    cuPhone = value["Phone No"];
    cuPhoto = value["Photo"];
    selectedCity = "";
  });
  await setLocalDetails(cuFName, cuLName, cuPhone, cuPhone, selectedCity);
}

Future getLocalDetails() async {
  // await buildDataBase("Nagpur");
  SharedPreferences sp = await SharedPreferences.getInstance();
  cuFName = sp.getString("cuFName") ?? cuFName;
  cuLName = sp.getString("cuLName") ?? cuLName;
  cuPhone = sp.getString("cuPhone") ?? cuPhone;
  cuPhoto = sp.getString("cuPhoto") ?? cuPhoto;
  selectedCity = sp.getString("selectedCity") ?? selectedCity;
  String? jsonList = sp.getString('metroStationsListJSON');
  metroStationsList = json
      .decode(jsonList!)
      .map<DropDownValueModel>((item) => DropDownValueModel.fromJson(item))
      .toList();
  stationList = metroStationsList.map((item) => item.value).toList();

  final dataJson = sp.getString('metroData');
  final dataX = jsonDecode(dataJson!);
  print(dataX);
  metroData =
      List<List<Object>>.from(dataX.map((list) => List<Object>.from(list)));
}

Future setLocalDetails(fname, lname, phone, photo, city) async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  sp.setString("cuFName", fname);
  sp.setString("cuLName", lname);
  sp.setString("cuPhone", phone);
  sp.setString("cuPhoto", photo);
  sp.setString("selectedCity", city);
  String metroStationsListJSON = json.encode(metroStationsList);
  sp.setString('metroStationsListJSON', metroStationsListJSON);
  final dataJson1 = jsonEncode(metroData);
  sp.setString('metroData', dataJson1);
}

Map<String, Color> lineColor = {
  "Red": Colors.red,
  "Blue": Colors.blue,
  "Pink": Colors.pink,
  "Black": Colors.black,
  "White": Colors.white,
  "Green": Colors.green,
  "Aqua": Colors.lightBlueAccent,
  "Purple": Colors.purple,
  "Yellow": Colors.yellow,
  "Orange": Colors.orange
};

Map<String, double> StationPosition = {
  'AhmedabadX': 23.0375565601606,
  'AhmedabadY': 72.56700922564633,
  'NagpurX': 21.1412657,
  'NagpurY': 79.0816802
};

Future buildDataBase(
    String cuFName, String cuLName, String cuPhone, String city) async {
  metroStationsList = [];
  metroGraph = {};
  stationList = [];
  fareMatrix = [];
  stationLineColor = {};
  metroData = [];

  final snapshot = await ref.ref("Cities/$city").orderByKey().get();
  List list = [];
  Map<dynamic, dynamic> values = snapshot.value as Map;
  values.forEach((key, value) {
    list.add(value);
  });

  for (int i = 0; i < list.length; i++) {
    Map temp = list[i];
    List temp1 = [];
    temp1.add(int.parse(temp["No"]));
    temp1.add(temp["Name"]);
    temp1.add(temp["X"]);
    temp1.add(temp["Y"]);
    temp1.add(temp["Line"]);
    temp1.add(temp["Terminal"]);
    // temp1.add(temp["Connected Line"]);
    // temp1.add(temp["Connected Stations"]);
    metroData.add(temp1);
  }

  for (int i = 0; i < metroData.length; i++) {
    metroData.sort((a, b) => a[1].compareTo(b[1]));
  }

  for (var i in metroData) {
    print(i);
  }

  for (int i = 0; i < metroData.length; i++) {
    metroStationsList
        .add(DropDownValueModel(name: metroData[i][1], value: metroData[i][1]));
  }
  // stationList = metroStationsList.map((item) => item.value).toList();

  await setLocalDetails(cuFName, cuLName, cuPhone, cuPhone, city);
}

openGoogleMap(String destination) async {
  final url =
      'https://www.google.com/maps/dir/?api=1&destination=${destination.replaceAll(" ", "_")} metro Station';
  // final url = 'https://www.google.com/maps/dir/?api=1&destination=$X,$Y';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

List FAQ = [
  [
    "I haven't received an OTP to log in/Sign up. What should I do ?",
    "By default, the Metro Mate app will recognize the OTP once you receive it. In case this doesn’t happen, then you can check your SMS inbox. If you still haven’t received it, then write to us at support@metromate.in"
  ],
  [
    "Why do I need to log in?",
    "Logging in to the Metro Mate app allows us to give you a personalised and seamless commute experience. You can save your select your city and add money to your wallet."
  ],
  [
    "What are the different ways to log in?",
    "There are only ways to log in to Metro Mate using your mobile number and an OTP."
  ],
  [
    "Why is the app asking to access my location?",
    "Since Metro Mate is a commuting app, accessing your location is important for us to provide the best service to you. It allows us to find metro stations near you"
  ],
  [
    "How can I cancel ticket and refund amount?",
    "Currently it is not possible to cancel your booked ticket and get refund."
  ],
  [
    "Metro Mate is not available in my city. How can I vote for my city?",
    "Metro Mate is available for all cities which have active metro rail service but some time due to any issue Metro Mate temporary unavailable for specific city."
  ],
  [
    "What do I do if the app shows an internet connectivity issue?",
    "Check the internet connectivity on your phone, or switch off your wifi/mobile data and restart it after a couple of minutes. You can also try closing and restarting Metro Mate app."
  ],
  [
    "How can I change my city on the Metro Mate app?",
    "It is very easy to change city. Follow step Open Drawer(Menu/Three Line) and you will get option like change/select city."
  ],
  [
    "Can I use the app offline?",
    "No, It is not possible to run app offline nut you can able to download ticket offline in gallery."
  ],
];
