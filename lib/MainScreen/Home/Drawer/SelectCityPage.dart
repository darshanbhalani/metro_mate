// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:metro_mate/MainScreen/Home/HomePage.dart';
import 'package:metro_mate/Variables.dart';

class SelectCityPage extends StatefulWidget {
  final String currentCity;
  const SelectCityPage({Key? key, required this.currentCity}) : super(key: key);
  @override
  State<SelectCityPage> createState() => _SelectCityPageState();
}

class _SelectCityPageState extends State<SelectCityPage> {
  String temp = selectedCity;
  int? flag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select City"),
        backgroundColor: PrimaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15,right: 15, top: 12,bottom: 80),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Adjust the number of columns here
            crossAxisSpacing:
                10.0, // Adjust the horizontal spacing between grid items
            mainAxisSpacing:
                10.0, // Adjust the vertical spacing between grid items
          ),
          itemCount: Cities.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                flag = index;
                temp = Cities[index];
                setState(() {});
              },
              child: GridTile(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: index == flag ? BorderColor : Colors.grey,
                          width: index == flag ? 2 : 1),
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // SizedBox(
                      //   height: 35,
                      // ),
                      // Image.asset("assets/images/cities/${Cities[index]}.jpg"),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          Cities[index],
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )),
                ),
              ),
            );
          },
        ),
      ),
      bottomSheet: Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: GestureDetector(
            onTap: () async {
              Loading(context);
              if (temp != "") {
                if (temp == "Ahmedabad" || temp == "Nagpur") {
                  if (temp != widget.currentCity) {
                    selectedCity = temp;
                    setState(() {});
                    await buildDataBase(cuFName,cuLName,cuPhone,selectedCity);
                    await setLocalDetails(
                        cuFName, cuLName, cuPhone, cuPhoto, selectedCity);
                  }
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                          (route) => false);
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => HomePage()));
                } else {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Sorry !! Currently Metro Mate is not available for selected city"),
                  ));
                }
              } else {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Please selected city"),
                ));
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
                    "Next",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )),
            ),
          ),
        ),
      ),
    );
  }
}