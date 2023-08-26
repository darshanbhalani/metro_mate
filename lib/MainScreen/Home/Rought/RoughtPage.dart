import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:metro_mate/MainScreen/Home/Rought/Route.dart';
import 'package:metro_mate/MainScreen/Home/Rought/Temp.dart';
import 'package:metro_mate/Variables.dart';

class RoutePage extends StatefulWidget {
  const RoutePage({Key? key}) : super(key: key);

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  final _controller1 = SingleValueDropDownController();
  final _controller2 = SingleValueDropDownController();
  final _formkey = GlobalKey<FormState>();
  List<List<dynamic>> queue = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PrimaryColor,
        title: const Text("Search Route"),
      ),
      body: Form(
        key: _formkey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropField(
                  context, "Source", metroStationsList, _controller1, true),
              DropField(context, "Destination", metroStationsList, _controller2, true),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: GestureDetector(
            onTap: () async {
              if(_formkey.currentState!.validate()){
                List stationList1=[];
                Loading(context);
                print("LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL");
                final snapshot= await ref.ref("Cities/$selectedCity").orderByKey().get();
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
                  temp1.add(temp["Line"]);
                  temp1.add(temp["Connected Stations"]);
                  stationList1.add(temp1);
                }
                for(int i=0;i<stationList1.length;i++){
                  stationList1.sort((a, b) => a[1].compareTo(b[1]));
                }

                stationLineColor={};
                print(stationList1);
                print(stationList1.length);

                for(int i=0;i<stationList1.length;i++) {
                  stationLineColor[stationList1[i][1]]=lineColor[stationList1[i][2]]!;
                }
                print("TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT");

                for (var item in stationList1) {
                  String key = item[1];
                  Set<String> value = Set<String>.from(item[3]);
                  metroGraph[key] = value;
                }
                Graph graph = Graph();
                List<String>? path = graph.bfs(_controller1.dropDownValue!.value.toString(), _controller2.dropDownValue!.value.toString());
                Navigator.pop(context);
                if (path != null) {
                  List route = path;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RouteViewPage(start:_controller1.dropDownValue!.value.toString(),end:_controller2.dropDownValue!.value.toString(),list: route),
                      ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Source and Destination both are Same !"),
                  ));
                }
              }
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: PrimaryColor,
              ),
              child:const Center(
                  child: Text(
                    "Search",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )),
            ),
          ),
        ),
      ),
    );
  }

  DropField(context, String lable, List<DropDownValueModel> items,
      SingleValueDropDownController controller, bool condition) {
    return Column(
      children: [
        DropDownTextField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select an option';
            }
            return null;
          },
          isEnabled: condition,
          clearOption: false,
          onChanged: (value) async {},
          controller: controller,
          dropDownItemCount: 5,
          dropDownList: items,
          dropdownRadius: 0,
          textFieldDecoration: InputDecoration(
            labelStyle: const TextStyle(
              color: Colors.black87
            ),
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
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: PrimaryColor,
              ),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
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
}
