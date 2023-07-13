import 'package:flutter/material.dart';
import 'package:metro_mate/Variables.dart';

class FindNearestStationPage extends StatefulWidget {
  const FindNearestStationPage({super.key});

  @override
  State<FindNearestStationPage> createState() => _FindNearestStationPageState();
}

class _FindNearestStationPageState extends State<FindNearestStationPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: InkWell(
        onTap: () async {

        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: PrimaryColor,
            ),
            child: Center(
                child: Text(
              "Search",
              style: TextStyle(fontSize: 20, color: Colors.white),
            )),
          ),
        ),
      ),
    );
  }
}
