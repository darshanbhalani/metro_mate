import 'dart:convert';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metro_mate/MainScreen/Home/HomePage.dart';
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


SendOTP(context, String pnone) async {
  await auth
      .verifyPhoneNumber(
        phoneNumber: '+91 $pnone',
        codeSent: (String verificationId, int? resendToken) async {
          verificationId = verificationId;
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OTPVarificationPage(
                    phone: '+91 $pnone', verificationId: verificationId),
              ));
        },
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {},
        codeAutoRetrievalTimeout: (String verificationId) {
        },
        verificationFailed: (FirebaseAuthException error) {},
      )
      .whenComplete(() {});
}

verifyOTP(context, verificationId, String code, function) async {
  Loading(context);
  PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: code);
  await auth.signInWithCredential(credential).whenComplete(() async {
    await function;
    Navigator.pop(context);
    if (selectedCity == "") {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SelectCityPage(currentCity: selectedCity),
          ));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ));
    }
  });
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
  await setDetails(cuFName, cuLName, cuPhone, cuPhone, selectedCity);
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
  List<String>? metroGraphData = sp.getStringList('metroGraph');
  for (String entry in metroGraphData!) {
    List<String> parts = entry.split(':');
    String key = parts[0];
    Set<String> values = Set<String>.from(parts[1].split(','));
    metroGraph[key] = values;
  }
  List stationListTemp = sp.getStringList('stationList')!;
  stationList = stationListTemp.map((item) => item).toList();
  List fareMatrixTemp = sp.getStringList('fareMatrix')!;
  fareMatrix = fareMatrixTemp.map((item) => item).toList();
  List cardListTemp = sp.getStringList('cardList')!;
  cardList = cardListTemp.map((item) => item).toList();

  List<String>? stationLineColorTemp = sp.getStringList('stationLineColor');
  for (String entry in stationLineColorTemp!) {
    List<String> parts = entry.split(':');
    String key = parts[0];
    Color value = parts[1] as Color;
    stationLineColor[key] = value;
  }
}

Future setDetails(fname,lname,phone,photo,city) async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  sp.setString("cuFName", fname);
  sp.setString("cuLName", lname);
  sp.setString("cuPhone", phone);
  sp.setString("cuPhoto", photo);
  sp.setString("selectedCity", city);
  String metroStationsListJSON = json.encode(metroStationsList);
  sp.setString('metroStationsListJSON', metroStationsListJSON);
  sp.setStringList(
    'metroGraph',
    metroGraph.entries
        .map((entry) => '${entry.key}:${entry.value.join(',')}')
        .toList(),
  );
  sp.setStringList('stationList', stationList.map((item) => item.toString()).toList());
  sp.setStringList('fareMatrix', fareMatrix.map((item) => item.toString()).toList());
  sp.setStringList('cardList', cardList.map((item) => item.toString()).toList());
  List<String> stationLineColorTemp = stationLineColor.entries
      .map((entry) => '${entry.key}:${entry.value}')
      .toList();
  sp.setStringList('stationLineColor', stationLineColorTemp);

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
  metroGraph = {};
  stationList=[];
  fareMatrix=[];
  stationLineColor= {};
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
  for (var item in stationList) {
    String key = item[1];
    Set<String> value = Set<String>.from(item[7]);
    metroGraph[key] = value;
  }
  //Fare Matrix
  final snapshot1 =
  await ref.ref("Fare/$city/locations").orderByKey().get();
  List<dynamic> values1 = snapshot1.value as List<dynamic>;
  List<Object> list1 = List<Object>.from(values1);
  final snapshot2 =
  await ref.ref("Fare/$city/distances").orderByKey().get();
  List<dynamic> values2 = snapshot2.value as List<dynamic>;
  List<Object> list2 = List<Object>.from(values2);
  fareMatrix.add(list1);
  for (var x in list2){
    fareMatrix.add(x);
  }
}