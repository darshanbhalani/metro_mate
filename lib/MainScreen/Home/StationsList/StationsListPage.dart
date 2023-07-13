import 'package:flutter/material.dart';

class StationsListPage extends StatefulWidget {
  const StationsListPage({super.key});

  @override
  State<StationsListPage> createState() => _StationsListPageState();
}

class _StationsListPageState extends State<StationsListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stations List"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Total number of metro stations :- 31"),
              SizedBox(height: 2.5,),
              Text("Number of interchange stations :- 1"),
              SizedBox(height: 2.5,),
              Text("Number of Elevated stations :- 27"),
              SizedBox(height: 2.5,),
              Text("Number of underground stations :- 4"),
              SizedBox(height: 2.5,),
              Text("Number of stations At-Grade :- 0")
            ],
          ),
        ),
      ),
    );
  }
}
