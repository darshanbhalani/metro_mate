

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:metro_mate/MainScreen/Home/Drawer/DrawerPage.dart';
import 'package:metro_mate/Variables.dart';

class BookingPage extends StatefulWidget {
  // final String phone;
  const BookingPage({Key? key}) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PrimaryColor,
        title: const Text("Bookings History"),
      ),
      drawer: DrawerPage(),
      body: StreamBuilder(
        stream: fire.collection("Tickets").where("Phone No",isEqualTo:cuPhone).orderBy("DateTime", descending: true).snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(color: PrimaryColor,),
            );
          }
          return ListView(
            children:snapshot.data!.docs.map((snap) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: BGColor,
                      borderRadius: BorderRadius.circular(25)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(child: Text(snap["Metro"]+" Metro",style: TextStyle(fontWeight: FontWeight.bold),)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Container(
                                child: RichText(
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                  text: TextSpan(
                                    style: const TextStyle(color: Colors.black, fontSize: 36),
                                    children: <TextSpan>[
                                      TextSpan(text: snap["Source"], style: const TextStyle(fontWeight: FontWeight.bold)),
                                      const TextSpan(text: " to "),
                                      TextSpan(text: snap["Destination"],style: const TextStyle(fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  textScaleFactor: 0.5,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.currency_rupee),
                                Text(snap["Total Fare"],style: const TextStyle(
                                    fontSize: 20
                                ),)
                              ],
                            )
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             Column(
                              children: [
                                Text("Number of Tickets :- ${snap["Number of Tickets"]}"),
                                const SizedBox(height: 20,),
                                Text("Booking Time :- ${snap["Booking Time"]}"),
                                const SizedBox(height: 10,),
                                Text("Booking Date :- ${snap["Booking Date"]}"),
                              ],
                            ),
                            GestureDetector(
                              onTap: (){
                                Ticket(snap["QR Ticket"]);
                              },
                              child: Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius: BorderRadius.circular(25)
                                ),
                                child: const Icon(Icons.qr_code,color: Colors.white,size: 50,),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            }).toList()
          );
        },)
    );
  }
  Ticket(link){
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        content: Image.network(link,fit: BoxFit.cover,)
        );
    });
  }
}
