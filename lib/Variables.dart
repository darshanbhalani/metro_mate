import 'dart:ui';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Color PrimaryColor = Color.fromARGB(255, 255, 114, 94);
Color SecondryColor = Color.fromARGB(150, 255, 114, 94);

ShowField(String _lable, String _value, bool _flag) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(_lable,
          style: TextStyle(
            fontSize: 15,
          )),
      SizedBox(
        height: 5,
      ),
      TextFormField(
        enabled: _flag,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.teal,
          )),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.orange,
            width: 3,
          )),
          labelText: _value,
          labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          hintStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(
        height: 20,
      ),
    ],
  );
}



List<DropDownValueModel> Numbers = [
  DropDownValueModel(name: "1", value: 1),
  DropDownValueModel(name: "2", value: 2),
  DropDownValueModel(name: "3", value: 3),
  DropDownValueModel(name: "4", value: 4),
  DropDownValueModel(name: "5", value: 5),
  DropDownValueModel(name: "6", value: 6),
];

TFormField(context, String _lable, TextEditingController _controller,
    bool _condition, bool _flag) {
  return Column(
    children: [
      TextFormField(
          obscureText: _flag,
          enabled: _condition,
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
          inputFormatters: [
            LengthLimitingTextInputFormatter(10),
            FilteringTextInputFormatter.digitsOnly,
          ],
          onChanged: (value) {
            if (value.length == 10) {
              FocusScope.of(context).nextFocus();
            }
          }),
      SizedBox(height: 15),
    ],
  );
}

List<DropDownValueModel> Stations = [
DropDownValueModel(name: "APMC", value: "APMC"),
DropDownValueModel(name: "Jivrajpark", value: "Jivrajpark"),
DropDownValueModel(name: "Rajivnagar", value: "Rajivnagar"),
DropDownValueModel(name: "Shreyas", value: "Shreyas"),
DropDownValueModel(name: "Paldi", value: "Paldi"),
DropDownValueModel(name: "Gandhigram", value: "Gandhigram"),
DropDownValueModel(name: "Old High Court 1", value: "Old High Court 1"),
DropDownValueModel(name: "Usmanpura", value: "Usmanpura"),
DropDownValueModel(name: "Vijaynagar", value: "Vijaynagar"),
DropDownValueModel(name: "Vadaj", value: "Vadaj"),
DropDownValueModel(name: "Ranip", value: "Ranip"),
DropDownValueModel(name: "Sabarmati Railway Station", value: "Sabarmati Railway Station"),
DropDownValueModel(name: "AEC", value: "AEC"),
DropDownValueModel(name: "Sabarmati", value: "Sabarmati"),
DropDownValueModel(name: "Motera Stadium", value: "Motera Stadium"),
DropDownValueModel(name: "Thaltej Gam", value: "Thaltej Gam"),
DropDownValueModel(name: "Thaltej", value: "Thaltej"),
DropDownValueModel(name: "Doordarshankendra", value: "Doordarshankendra"),
DropDownValueModel(name: "Gurukul Road", value: "Gurukul Road"),
DropDownValueModel(name: "Gujarta University", value: "Gujarta University"),
DropDownValueModel(name: "Commerce Six Road", value: "Commerce Six Road"),
DropDownValueModel(name: "SP Stadium", value: "SP Stadium"),
DropDownValueModel(name: "Old High Court 2", value: "Old High Court 2"),
DropDownValueModel(name: "Shahpur", value: "Shahpur"),
DropDownValueModel(name: "Gheekanta", value: "Gheekanta"),
DropDownValueModel(name: "Kalupur Metro Station", value: "Kalupur Metro Station"),
DropDownValueModel(name: "Kankaria East", value: "Kankaria East"),
DropDownValueModel(name: "Apperel Park", value: "Apperel Park"),
DropDownValueModel(name: "Amraivadi", value: "Amraivadi"),
DropDownValueModel(name: "Rabari Colony", value: "Rabari Colony"),
DropDownValueModel(name: "Vastral", value: "Vastral"),
DropDownValueModel(name: "Nirant Cross Road", value: "Nirant Cross Road"),
DropDownValueModel(name: "Vastral Gam", value: "Vastral Gam")
];

List Price=[
['#','APMC', 'Jivrajpark', 'Rajivnagar', 'Shreyas', 'Paldi', 'Gandhigram', 'Old High Court 1', 'Usmanpura', 'Vijaynagar', 'Vadaj', 'Ranip', 'Sabarmati Railway Station', 'AEC', 'Sabarmati', 'Motera Stadium', 'Thaltej Gam', 'Thaltej', 'Doordarshankendra', 'Gurukul Road', 'Gujarta University', 'Commerce Six Road', 'SP Stadium', 'Old High Court 2', 'Shahpur', 'Gheekanta', 'Kalupur Metro Station', 'Kankaria East', 'Apperel Park', 'Amraivadi', 'Rabari Colony', 'Vastral', 'Nirant Cross Road', 'Vastral Gam'],
['APMC', '5', '5', '5', '10', '10', '10', '10', '15', '15', '15', '15', '20', '20', '20', '20', '20', '20', '15', '15', '15', '15', '15', '10', '15', '15', '15', '20', '20', '20', '20', '25', '25', '25'],
['Jivrajpark', '5', '5', '5', '5', '10', '10', '10', '10', '15', '15', '15', '15', '20', '20', '20', '20', '15', '15', '15', '15', '15', '10', '10', '15', '15', '15', '20', '20', '20', '20', '20', '25', '25'],
['Rajivnagar', '5', '5', '5', '5', '10', '10', '10', '10', '15', '15', '15', '15', '15', '20', '20', '15', '15', '15', '15', '15', '10', '10', '10', '10', '15', '15', '15', '20', '20', '20', '20', '25', '25'],
['Shreyas', '10', '5', '5', '5', '5', '10', '10', '10', '10', '15', '15', '15', '15', '15', '20', '15', '15', '15', '10', '10', '10', '10', '10', '10', '10', '15', '15', '15', '20', '20', '20', '20', '20'],
['Paldi', '10', '10', '10', '5', '5', '5', '5', '10', '10', '10', '10', '15', '15', '15', '15', '15', '15', '10', '10', '10', '10', '10', '5', '10', '10', '15', '15', '15', '15', '15', '20', '20', '20'],
['Gandhigram', '10', '10', '10', '10', '5', '5', '5', '5', '10', '10', '10', '10', '15', '15', '15', '15', '10', '10', '10', '10', '10', '5', '5', '10', '10', '10', '15', '15', '15', '15', '15', '20', '20'],
['Old High Court 1', '10', '10', '10', '10', '5', '5', '5', '5', '5', '10', '10', '10', '10', '15', '15', '10', '10', '10', '10', '10', '5', '5', '5', '5', '10', '10', '10', '15', '15', '15', '15', '15', '20'],
['Usmanpura', '15', '10', '10', '10', '10', '5', '5', '5', '5', '10', '10', '10', '10', '10', '15', '15', '10', '10', '10', '10', '5', '5', '5', '5', '10', '10', '10', '15', '15', '15', '15', '20', '20'],
['Vijaynagar', '15', '15', '15', '10', '10', '10', '5', '5', '5', '5', '5', '10', '10', '10', '10', '15', '15', '10', '10', '10', '10', '10', '5', '10', '10', '15', '15', '15', '15', '15', '20', '20', '20'],
['Vadaj', '15', '15', '15', '15', '10', '10', '10', '10', '5', '5', '5', '5', '10', '10', '10', '15', '15', '15', '10', '10', '10', '10', '10', '10', '10', '15', '15', '15', '20', '20', '20', '20', '20'],
['Ranip', '15', '15', '15', '15', '10', '10', '10', '10', '5', '5', '5', '5', '5', '10', '10', '15', '15', '15', '15', '10', '10', '10', '10', '10', '15', '15', '15', '20', '20', '20', '20', '20', '25'],
['Sabarmati Railway Station', '20', '15', '15', '15', '15', '10', '10', '10', '10', '5', '5', '5', '5', '5', '10', '20', '15', '15', '15', '15', '10', '10', '10', '10', '15', '15', '15', '20', '20', '20', '20', '25', '25'],
['AEC', '20', '20', '15', '15', '15', '15', '10', '10', '10', '10', '5', '5', '5', '5', '10', '20', '15', '15', '15', '15', '15', '10', '10', '15', '15', '15', '20', '20', '20', '20', '25', '25', '25'],
['Sabarmati', '20', '20', '20', '15', '15', '15', '15', '10', '10', '10', '10', '5', '5', '5', '5', '20', '20', '20', '15', '15', '15', '15', '15', '15', '15', '20', '20', '20', '25', '25', '25', '25', '25'],
['Motera Stadium', '20', '20', '20', '20', '15', '15', '15', '15', '10', '10', '10', '10', '10', '5', '5', '20', '20', '20', '20', '15', '15', '15', '15', '15', '20', '20', '20', '25', '25', '25', '25', '25', '25'],
['Thaltej Gam', '20', '20', '15', '15', '15', '15', '10', '15', '15', '15', '15', '20', '20', '20', '20', '5', '5', '5', '10', '10', '10', '10', '10', '15', '15', '15', '20', '20', '20', '20', '25', '25', '25'],
['Thaltej', '20', '15', '15', '15', '15', '10', '10', '10', '15', '15', '15', '15', '15', '20', '20', '5', '5', '5', '5', '10', '10', '10', '10', '10', '15', '15', '15', '20', '20', '20', '20', '25', '25'],
['Doordarshankendra', '15', '15', '15', '15', '10', '10', '10', '10', '10', '15', '15', '15', '15', '20', '20', '5', '5', '5', '5', '5', '10', '10', '10', '10', '15', '15', '15', '20', '20', '20', '20', '20', '25'],
['Gurukul Road', '15', '15', '15', '10', '10', '10', '10', '10', '10', '10', '15', '15', '15', '15', '20', '10', '5', '5', '5', '5', '5', '10', '10', '10', '10', '15', '15', '15', '20', '20', '20', '20', '20'],
['Gujarta University', '15', '15', '15', '10', '10', '10', '10', '10', '10', '10', '10', '15', '15', '15', '15', '10', '10', '5', '5', '5', '5', '5', '10', '10', '10', '15', '15', '15', '15', '20', '20', '20', '20'],
['Commerce Six Road', '15', '15', '10', '10', '10', '10', '5', '5', '10', '10', '10', '10', '15', '15', '15', '10', '10', '10', '5', '5', '5', '5', '5', '10', '10', '10', '15', '15', '15', '15', '20', '20', '20'],
['SP Stadium', '15', '10', '10', '10', '10', '5', '5', '5', '10', '10', '10', '10', '10', '15', '15', '10', '10', '10', '10', '5', '5', '5', '5', '5', '10', '10', '10', '15', '15', '15', '15', '20', '20'],
['Old High Court 2', '10', '10', '10', '10', '5', '5', '5', '5', '5', '10', '10', '10', '10', '15', '15', '10', '10', '10', '10', '10', '5', '5', '5', '5', '10', '10', '10', '15', '15', '15', '15', '15', '20'],
['Shahpur', '15', '15', '10', '10', '10', '10', '5', '5', '10', '10', '10', '10', '15', '15', '15', '15', '10', '10', '10', '10', '10', '5', '5', '5', '5', '10', '10', '10', '15', '15', '15', '15', '15'],
['Gheekanta', '15', '15', '15', '10', '10', '10', '10', '10', '10', '10', '15', '15', '15', '15', '20', '15', '15', '15', '10', '10', '10', '10', '10', '5', '5', '5', '10', '10', '10', '10', '15', '15', '15'],
['Kalupur Metro Station', '15', '15', '15', '15', '15', '10', '10', '10', '15', '15', '15', '15', '15', '20', '20', '15', '15', '15', '15', '15', '10', '10', '10', '10', '5', '5', '5', '10', '10', '10', '10', '10', '15'],
['Kankaria East', '20', '20', '15', '15', '15', '15', '10', '10', '15', '15', '15', '15', '20', '20', '20', '20', '15', '15', '15', '15', '15', '10', '10', '10', '10', '5', '5', '5', '10', '10', '10', '10', '10'],
['Apperel Park', '20', '20', '20', '15', '15', '15', '15', '15', '15', '15', '20', '20', '20', '20', '25', '20', '20', '20', '15', '15', '15', '15', '15', '10', '10', '10', '5', '5', '5', '5', '10', '10', '10'],
['Amraivadi', '20', '20', '20', '20', '15', '15', '15', '15', '15', '20', '20', '20', '20', '25', '25', '20', '20', '20', '20', '15', '15', '15', '15', '15', '10', '10', '10', '5', '5', '5', '5', '10', '10'],
['Rabari Colony', '20', '20', '20', '20', '15', '15', '15', '15', '15', '20', '20', '20', '20', '25', '25', '20', '20', '20', '20', '20', '15', '15', '15', '15', '10', '10', '10', '5', '5', '5', '5', '5', '10'],
['Vastral', '25', '20', '20', '20', '20', '15', '15', '15', '20', '20', '20', '20', '20', '25', '25', '25', '20', '20', '20', '20', '20', '15', '15', '15', '15', '10', '10', '10', '5', '5', '5', '5', '5'],
['Nirant Cross Road', '25', '25', '25', '20', '20', '20', '15', '20', '20', '20', '20', '25', '25', '25', '25', '25', '25', '20', '20', '20', '20', '20', '15', '15', '15', '10', '10', '10', '10', '5', '5', '5', '5'],
['Vastral Gam', '25', '25', '25', '20', '20', '20', '20', '20', '20', '20', '25', '25', '25', '25', '25', '25', '25', '25', '20', '20', '20', '20', '20', '15', '15', '15', '10', '10', '10', '10', '5', '5', '5']
];

Loading(context) {
  return showDialog(
    barrierDismissible: false,
      context: context,
      builder: (context) {
        return Container(
            child: Center(
                child: CircularProgressIndicator(color: PrimaryColor)
            ));
      });
}

List Cities=["Ahmedabad","Agra","Bengaluru","Bhopal","Chennai","Delhi","Hyderabad","Jaipur","Kanpur","Kochi","Kolkata","Lucknow","Mumbai","Nagpur","Noida","Pune"];
String selectedCity = "";


var graph = {
'Gyaspur Depot': {'APMC'},
'APMC': {'Gyaspur Depot', 'Jivraj'},
'Jivraj': {'APMC', 'Rajivnagar'},
'Rajivnagar': {'Jivraj', 'Shreyas'},
'Shreyas': {'Rajivnagar', 'Paldi'},
'Paldi': {'Shreyas', 'Gandhigram'},
'Gandhigram': {'Paldi', 'Old High Court'},
'Old High Court': {'Gandhigram', 'Usmanpura', 'Stadium', 'Sahpur'},
'Usmanpura': {'Old High Court', 'Vijaynagar'},
'Vijaynagar': {'Usmanpura', 'Vadaj'},
'Vadaj': {'Vijaynagar', 'Ranip'},
'Ranip': {'Vadaj', 'Sabarmati Railway Station'},
'Sabarmati Railway Station': {'Ranip', 'AEC'},
'AEC': {'Sabarmati Railway Station', 'Sabarmati'},
'Sabarmati': {'AEC', 'Motera Stadium'},
'Motera Stadium': {'Sabarmati'},
'Stadium': {'Old High Court', 'Commerce Six Roads'},
'Commerce Six Roads': {'Stadium', 'Gujarat University'},
'Gujarat University': {'Commerce Six Roads', 'Gurukul Road'},
'Gurukul Road': {'Gujarat University', 'Doordarshankendra'},
'Doordarshankendra': {'Gurukul Road', 'Thaltej'},
'Thaltej': {'Doordarshankendra', 'Thaltej Gam'},
'Thaltej Gam': {'Thaltej'},
'Sahpur': {'Old High Court', 'Gheekanta'},
'Gheekanta': {'Sahpur', 'Kalupur Railway Station'},
'Kalupur Railway Station': {'Gheekanta', 'Kankaria East'},
'Kankaria East': {'Kalupur Railway Station', 'Apparel Park'},
'Apparel Park': {'Kankaria East', 'Amraivadi'},
'Amraivadi': {'Apparel Park', 'Rabari Colony'},
'Rabari Colony': {'Amraivadi', 'Vastral'},
'Vastral': {'Rabari Colony', 'Nirant Cross Road'},
'Nirant Cross Road': {'Vastral', 'Vastral Gam'},
'Vastral Gam': {'Nirant Cross Road'}
};