import 'package:flutter/material.dart';
import 'package:metro_mate/MainScreen/Bookings/BookingsPage.dart';
import 'package:metro_mate/MainScreen/Home/Drawer/DrawerPage.dart';
import 'package:metro_mate/MainScreen/Home/Drawer/WalletPage.dart';
import 'package:metro_mate/MainScreen/Home/FindNearestStation/FindNearestStationPage.dart';
import 'package:metro_mate/MainScreen/Home/MetroMap/MetroMapPage.dart';
import 'package:metro_mate/MainScreen/Home/Rought/RoughtPage.dart';
import 'package:metro_mate/MainScreen/Profile/ProfilePage.dart';
import 'package:metro_mate/MainScreen/Home/RechargeMetroCard/RechareMetroCardPage.dart';
import 'package:metro_mate/MainScreen/Home/StationsList/StationsListPage.dart';
import 'package:metro_mate/MainScreen/Home/TicketBooking/TicketBookingPage.dart';
import 'package:metro_mate/Variables.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    Container(),
    BookingPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _selectedIndex == 0
          ? AppBar(
              backgroundColor: PrimaryColor,
              iconTheme: IconThemeData(color: Colors.black),
              elevation: 0,
              toolbarHeight: 80,
              title: Text(
                "Metro Mate",
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: IconButton(
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WalletPage(),
                      ));
                },
                icon: Icon(Icons.account_balance_wallet_outlined,size: 25,color: Colors.white,)
            ),
          )
        ],
            )
          : null,
      drawer: DrawerPage(),
      body: _selectedIndex == 0
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 180,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: PrimaryColor,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(25),
                                bottomRight: Radius.circular(25),
                              )),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Hi, ${cuFName}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 26),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "Welcome to Metro Mate.",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Text(
                                      "Your Metro Companion.",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.pin_drop_rounded),
                                            Text(
                                              selectedCity,
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TicketBookingPage(),
                                  ));
                            },
                            child: Container(
                              height: 90,
                              width: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: BGColor,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                      image: AssetImage(
                                          "assets/icons/BookTicket.png"),
                                    )),
                                  ),
                                  Text(
                                    "Booking",
                                    style: TextStyle(color: PrimaryColor),
                                  )
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RoutePage(),
                                  ));
                            },
                            child: Container(
                              height: 90,
                              width: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: BGColor,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                      image: AssetImage(
                                          "assets/icons/Route.png"),
                                    )),
                                  ),
                                  Text(
                                    "Route",
                                    style: TextStyle(color: PrimaryColor),
                                  )
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        FindNearestStationPage(),
                                  ));
                            },
                            child: Container(
                              height: 90,
                              width: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: BGColor,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage("assets/icons/NearestStation.png"),
                                        )
                                    ),
                                  ),
                                  Text(
                                    "Find Nearest",
                                    style: TextStyle(color: PrimaryColor),
                                  ),
                                  Text(
                                    "Station",
                                    style: TextStyle(color: PrimaryColor),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MetroMapPage(
                                      city: selectedCity.toString(),
                                    ),
                                  ));
                            },
                            child: Container(
                              height: 90,
                              width: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: BGColor,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage("assets/icons/MetroMap.png"),
                                        )
                                    ),
                                  ),
                                  Text(
                                    "Metro Map",
                                    style: TextStyle(color: PrimaryColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        RechargeMetroCardPage(),
                                  ));
                            },
                            child: Container(
                              height: 90,
                              width: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: BGColor,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage("assets/icons/MetroCard.png"),
                                        )
                                    ),
                                  ),
                                  Text(
                                    "Recharge",
                                    style: TextStyle(color: PrimaryColor),
                                  ),
                                  Text(
                                    "Metro Card",
                                    style: TextStyle(color: PrimaryColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StationsListPage(),
                                  ));
                            },
                            child: Container(
                              height: 90,
                              width: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: BGColor,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage("assets/icons/StationList.png"),
                                        )
                                    ),
                                  ),
                                  Text(
                                    "Stations",
                                    style: TextStyle(color: PrimaryColor),
                                  ),
                                  Text(
                                    "List",
                                    style: TextStyle(color: PrimaryColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            )
          : _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
        child: BottomNavigationBar(
          elevation: 25,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white60,
          type: BottomNavigationBarType.fixed,
          backgroundColor: PrimaryColor,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.line_style_rounded),
              label: 'Bookings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
