import 'package:flutter/material.dart';
import 'package:metro_mate/Variables.dart';

class StationsListPage extends StatefulWidget {
  const StationsListPage({super.key});

  @override
  State<StationsListPage> createState() => _StationsListPageState();
}

class _StationsListPageState extends State<StationsListPage> {

  @override
  void initState() {
    print(metroData);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PrimaryColor,
        title: const Text("Stations List"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 10),
          itemCount:metroData.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 50,
                  child: ListTile(
                    leading: Text("${index+1}.",style: const TextStyle(fontSize: 18),),
                    title: Text(metroData[index][1],style: const TextStyle(fontSize: 18),),
                    trailing: IconButton(
                        onPressed: () async {
                          openGoogleMap((metroData[index][1]).toString()+" "+selectedCity);
                        },
                        icon: const Icon(Icons.directions)),
                  ),
                ),
                const Divider()
              ],
            );
          }),
    );
  }
}

