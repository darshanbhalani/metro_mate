import 'package:flutter/material.dart';
import 'package:metro_mate/MainScreen/Home/HomePage.dart';
import 'package:metro_mate/Variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectCityPage extends StatefulWidget {
  final String currentCity;
  const SelectCityPage({Key? key,required this.currentCity}) : super(key: key);
  @override
  State<SelectCityPage> createState() => _SelectCityPageState();
}

class _SelectCityPageState extends State<SelectCityPage> {

  String temp=selectedCity;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select City"),
      ),
      body: ListView.builder(
        itemCount: Cities.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: (){
                  temp=Cities[index].toString();
                  setState(() {
                  });
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 75,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage("assets/images/Ahmedabad.png")
                                  )
                              ),
                            ),
                            SizedBox(width: 20,),
                            Text(Cities[index],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)
                          ],
                        ),
                        Visibility(
                            visible: temp==Cities[index],
                            child: Icon(Icons.done_outline,color: PrimaryColor,))
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,)
            ],
          );
        }),
      bottomSheet: InkWell(
        onTap: () async {
          if(temp != widget.currentCity){
            selectedCity=temp;
            SharedPreferences sp = await SharedPreferences.getInstance();
            sp.setString("cuFName", cuFName);
            setState(() {
            });
          }
          // Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: PrimaryColor,
            ),
            child: Center(child: Text("Submit",style: TextStyle(fontSize:20,color: Colors.white),)),
          ),
        ),
      ),
    );
  }
}
