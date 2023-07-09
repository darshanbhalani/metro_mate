import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:metro_mate/Route.dart';
import 'package:metro_mate/Temp.dart';
import 'package:metro_mate/Variables.dart';

class RoughtPage extends StatefulWidget {
  const RoughtPage({Key? key}) : super(key: key);

  @override
  State<RoughtPage> createState() => _RoughtPageState();
}

class _RoughtPageState extends State<RoughtPage> {
  final _controller1 = SingleValueDropDownController();
  final _controller2 = SingleValueDropDownController();
  final _formkey = GlobalKey<FormState>();
  List<List<dynamic>> queue = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PrimaryColor,
        title: Text("Search Rought"),
      ),
      body: Form(
        key: _formkey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropField(context, "Source", Stations, _controller1, true),
              DropField(context, "Destination", Stations, _controller2, true),
            ],
          ),
        ),
      ),
      bottomSheet: InkWell(
        onTap: (){
         Loading(context);
          Graph graph = Graph();
          List<String>? path = graph.bfs(_controller1.dropDownValue!.value.toString(), _controller2.dropDownValue!.value.toString());
         Navigator.pop(context);
         if (path != null) {
            List route = path;
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RoutePage(start:_controller1.dropDownValue!.value.toString(),end:_controller2.dropDownValue!.value.toString(),list: route,),
                ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Source and Destination both are Same !"),
            ));
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
            child: Center(child: Text("Search",style: TextStyle(fontSize:20,color: Colors.white),)),
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
          isEnabled: condition,
          clearOption: false,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select an option';
            }
            return null;
          },
          onChanged: (value) async {
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
}





