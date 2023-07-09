import 'package:flutter/material.dart';
import 'package:metro_mate/Variables.dart';

class BookingPage extends StatefulWidget {
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
        title: Text("Bookings History"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: 200,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(25)
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Station A --> Station B",style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 20
                        ),)
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.currency_rupee),
                        Text("0.0",style: TextStyle(
                          fontSize: 20
                        ),)
                      ],
                    )
                  ],
                ),
                Row(
                  children: [

                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text("Number of Tickets :- 10"),
                        SizedBox(height: 20,),
                        Text("Booking Time :- "),
                        SizedBox(height: 10,),
                        Text("Validity Time :- "),
                      ],
                    ),
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(25)
                      ),
                      child: Icon(Icons.qr_code,color: Colors.white,size: 50,),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
