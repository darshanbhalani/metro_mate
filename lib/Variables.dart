import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metro_mate/LogIn/OTPVarificationPage.dart';
import 'package:metro_mate/MainScreen/Home/Drawer/SelectCityPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore fire = FirebaseFirestore.instance;
FirebaseDatabase ref = FirebaseDatabase.instance;

Color PrimaryColor = const Color.fromARGB(255, 255, 114, 94);
Color SecondryColor = const Color.fromARGB(150, 255, 114, 94);

String selectedCity = "";
String cuFName = "";
String cuLName = "";
String cuPhone = "";
String cuPhoto = "";
List cardList=[];
List<DropDownValueModel> metroStationsList = [];
Map<String, Set<String>> metroGraph = {};
List stationList=[];
List fareMatrix=[];
Map<String,Color> stationLineColor= {};


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
          labelStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
          obscureText: flag,
          enabled: condition,
          validator: (value) {
            if (controller.text.length != 10) {
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
              color: PrimaryColor,
              width: 2,
            )),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            labelText: lable,
            labelStyle: const TextStyle(
              fontSize: 15,
              color: Colors.black
            ),
          ),
          inputFormatters: [
            LengthLimitingTextInputFormatter(10),
            FilteringTextInputFormatter.digitsOnly,
          ],
          onChanged: (value) {
            if (value.length == 10) {
              FocusScope.of(context).nextFocus();
            }
          }),
      const SizedBox(height: 15),
    ],
  );
}

Loading(context) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator(color: PrimaryColor));
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


SendOTP(context, String pnone,bool flag) async {
  try{
    await auth
        .verifyPhoneNumber(
      phoneNumber: '+91 $pnone',
      codeSent: (String verificationId, int? resendToken) async {
        verificationId = verificationId;
        Navigator.pop(context);
        if(flag) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    OTPVarificationPage(
                        phone: '+91 $pnone', verificationId: verificationId),
              ));
        }
      },
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {},
      codeAutoRetrievalTimeout: (String verificationId) {
      },
      verificationFailed: (FirebaseAuthException error) {},
    );
  }catch(e){
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Oops! Somthing went wrong please try again later"),
    ));
  }
}

verifyOTP(context, verificationId, String code, function) async {
  Loading(context);
  try {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: code);
    UserCredential userCredential = await auth.signInWithCredential(credential);
    if (userCredential.user != null) {
      await function;
      Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SelectCityPage(currentCity: selectedCity),
            ));
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Oops! Somthing went wrong please try again later"),
      ));
    }
  } catch (e) {
    Navigator.pop(context);
    if(e.hashCode.toString()=="37476458"){
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Oops! Wrong OTP"),
    ));}
    else if(e.hashCode.toString()=="463626008"){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Oops! OTP timed out please resend OTP"),
      ));}
    else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Oops! Somthing went wrong please try again later"),
      ));
    }
  }
}

Future SignUp(String fname, String lname, String phone) async {
  fire.collection("Users").doc(phone).set({
    "First Name": fname.toUpperCase(),
    "Last Name": lname.toUpperCase(),
    "Phone No": phone,
    "Photo": ""
  });
}

Temp() {}

Future getUserData(String phone) async {
  fire.collection("Users").doc(phone).get().then((value) {
    cuFName = value["First Name"];
    cuLName = value["Last Name"];
    cuPhone = value["Phone No"];
    cuPhoto = value["Photo"];
    selectedCity="";
  });
  await setLocalDetails(cuFName, cuLName, cuPhone, cuPhone, selectedCity);
}

Future getLocalDetails() async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  cuFName = sp.getString("cuFName") ?? cuFName;
  cuLName = sp.getString("cuLName") ?? cuLName;
  cuPhone = sp.getString("cuPhone") ?? cuPhone;
  cuPhoto = sp.getString("cuPhoto") ?? cuPhoto;
  selectedCity = sp.getString("selectedCity") ?? selectedCity;
  String? jsonList = sp.getString('metroStationsListJSON');
  metroStationsList = json.decode(jsonList!).map<DropDownValueModel>((item) => DropDownValueModel.fromJson(item)).toList();
}

Future setLocalDetails(fname,lname,phone,photo,city) async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  sp.setString("cuFName", fname);
  sp.setString("cuLName", lname);
  sp.setString("cuPhone", phone);
  sp.setString("cuPhoto", photo);
  sp.setString("selectedCity", city);
  String metroStationsListJSON = json.encode(metroStationsList);
  sp.setString('metroStationsListJSON', metroStationsListJSON);
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

Future buildDataBase(String city) async{
  metroStationsList = [];
  // metroGraph = {};
  // stationList=[];
  // fareMatrix=[];
  // stationLineColor= {};
  //Metro Stations List
  final snapshot= await ref.ref("Cities/$city").orderByKey().get();
  List list=[];
  Map<dynamic,dynamic> values = snapshot.value as Map;
  values.forEach((key, value) {
    list.add(value);
  });

  for(int i=0;i<list.length;i++){
    Map temp =list[i];
    List temp1=[];
    temp1.add(int.parse(temp["No"]));
    temp1.add(temp["Name"]);
    temp1.add(temp["X"]);
    temp1.add(temp["Y"]);
    temp1.add(temp["Line"]);
    temp1.add(temp["Terminal"]);
    temp1.add(temp["Connected Line"]);
    temp1.add(temp["Connected Stations"]);
    stationList.add(temp1);
  }
  for(int i=0;i<stationList.length;i++){
    stationList.sort((a, b) => a[1].compareTo(b[1]));
  }

  for(int i=0;i<stationList.length;i++) {
    metroStationsList.add(DropDownValueModel(
        name: stationList[i][1],
        value: stationList[i][1]));
    stationLineColor[stationList[i][1]]=lineColor[stationList[i][4]]!;
  }
  // for (var item in stationList) {
  //   String key = item[1];
  //   Set<String> value = Set<String>.from(item[7]);
  //   metroGraph[key] = value;
  // }
  //Fare Matrix
  // final snapshot1 =
  // await ref.ref("Fare/$city/locations").orderByKey().get();
  // List<dynamic> values1 = snapshot1.value as List<dynamic>;
  // List<Object> list1 = List<Object>.from(values1);
  // final snapshot2 =
  // await ref.ref("Fare/$city/distances").orderByKey().get();
  // List<dynamic> values2 = snapshot2.value as List<dynamic>;
  // List<Object> list2 = List<Object>.from(values2);
  // fareMatrix.add(list1);
  // for (var x in list2){
  //   fareMatrix.add(x);
  // }
  await setLocalDetails(cuFName, cuLName, cuPhone, cuPhone, selectedCity);
}


List FAQ=[
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