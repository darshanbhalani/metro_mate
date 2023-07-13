import 'package:flutter/material.dart';
import 'package:metro_mate/Variables.dart';

class RoutePage extends StatefulWidget {
  final String start;
  final String end;
  final List list;
  const RoutePage({super.key,required this.start,required this.end,required this.list});

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: PrimaryColor,
          title: Text(widget.start + " to " + widget.end),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 12),
          child: ListView.builder(
              itemCount: widget.list.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: 60,
                                width: 6,
                                color: LineColor[C[S.indexOf("${widget.list[index]}")]],
                              ),
                              Center(child: Icon(Icons.circle,color:LineColor[C[S.indexOf("${widget.list[index]}")]]))
                            ],
                          ),
                          SizedBox(width: 25,),
                          Text(widget.list[index])
                        ],
                      ),
                    )
                );
              }),
        )
    );
  }

  Box(){
    return  Container(
        height: 60,
        color: Colors.red,
        child: Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 60,
                    width: 6,
                    color: Colors.black,
                  ),
                  Center(child: const Icon(Icons.circle,color: Colors.black,))
                ],
              ),
              SizedBox(width: 25,),
              Text("Name")
            ],
          ),
        )
    );
  }
}
