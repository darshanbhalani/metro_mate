import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:metro_mate/Variables.dart';

class FindNearestStationPage extends StatefulWidget {
  const FindNearestStationPage({super.key});

  @override
  State<FindNearestStationPage> createState() => _FindNearestStationPageState();
}

class _FindNearestStationPageState extends State<FindNearestStationPage> {
  List markersList = [];
  double userLocationX = 0.0;
  double userLocationY = 0.0;

  final GlobalKey _draggableKey = GlobalKey();

  final Set<Marker> _markers = {};
  List<Map<String, dynamic>> markerData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nearest Stations"),
        backgroundColor: PrimaryColor,
      ),
      body: GoogleMap(
        // trafficEnabled: true,
        indoorViewEnabled: true,
        myLocationEnabled: true,
        onMapCreated: (controller) async {
          getCurrentLocation();
          getData();
          setState(() {});
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(StationPosition["${selectedCity}X"]!,
              StationPosition["${selectedCity}Y"]!), // Initial map location
          zoom: 12.0,
        ),
        minMaxZoomPreference: const MinMaxZoomPreference(5.0, 20.0),
        myLocationButtonEnabled: true,
        markers: _markers,
        zoomControlsEnabled: false,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: FloatingActionButton.extended(
          elevation: 0,
          focusElevation: 0,
          hoverElevation: 0,
          highlightElevation: 0,
          disabledElevation: 0,
          onPressed: () {},
          backgroundColor: Colors.transparent,
          label: Container(
            alignment: Alignment.center,
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: GestureDetector(
                onTap: () async {
                  openBottomSheet();
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: PrimaryColor,
                  ),
                  child: const Center(
                      child: Text(
                    "Search",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  openBottomSheet() {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return DraggableScrollableSheet(
              key: _draggableKey,
              initialChildSize: 0.5, // Initial height as half of the screen
              minChildSize: 0.2,
              maxChildSize: 1.0,
              expand: true,
              builder: (context, scrollController) {
                return NotificationListener<ScrollNotification>(
                    child: Container(
                  color: Colors.white.withOpacity(1),
                  child: ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      itemCount: markersList.length,
                      itemBuilder: (BuildContext context, int index) {
                       double x1=userLocationX* (3.14159265358979323846264338327950288 / 180.0);
                       double y1=userLocationY* (3.14159265358979323846264338327950288 / 180.0);
                       double x2=double.parse(markersList[index][1])* (3.14159265358979323846264338327950288 / 180.0);
                       double y2=double.parse(markersList[index][2])* (3.14159265358979323846264338327950288 / 180.0);
                       double dlon = x2 - x1;
                        double dlat = y2 - y1;
                       double a = (sin(dlat / 2)*sin(dlat / 2)) + cos(y1) * cos(y2) * (sin(dlon / 2)*sin(dlon / 2));
                        double d=(2 * asin(sqrt(a)))*6371;
                       // double d = Geolocator.distanceBetween(
                       //      userLocationX,
                       //      double.parse(markersList[index][1]),
                       //      userLocationY,
                       //      double.parse(markersList[index][2]));
                       //  print("-------------------------------------------");
                       //  print(userLocationX);
                       //  print(double.parse(markersList[index][1]));
                       //  print(userLocationY);
                       //  print(double.parse(markersList[index][2]));
                       //  print(d);
                       // double d = gmaps.SphericalUtil.computeDistanceBetween(
                       //   gmaps.LatLng(userLocationX, userLocationY),
                       //   gmaps.LatLng(double.parse(markersList[index][1]), double.parse(markersList[index][2])),
                       // );
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 50,
                              child: GestureDetector(
                                onTap: () async {
                                  await openGoogleMap(markersList[index][0] +
                                      " " +
                                      selectedCity);
                                },
                                child: ListTile(
                                  leading: Text(
                                    "${index + 1}.",
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  title: Text(
                                    markersList[index][0],
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  trailing: Text("${d.toStringAsFixed(0)} km"),
                                ),
                              ),
                            ),
                            const Divider()
                          ],
                        );
                      }),
                ));
              });
        });
  }

  Future getData() async {
    Loading(context);
    late LocationData locationData;
    Location location = Location();
    markerData = [];
    try {
      locationData = await location.getLocation();
    } catch (e) {}
    userLocationX = locationData.latitude!.toDouble();
    userLocationY = locationData.longitude!.toDouble();
    _markers.add(Marker(
      infoWindow: const InfoWindow(title: "Your Location"),
      markerId: const MarkerId("Your Location"),
      position: LatLng(locationData.latitude!.toDouble(),
          locationData.longitude!.toDouble()),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    ));
    for (int i = 0; i < metroData.length; i++) {
      List temp1 = [];
      temp1.add(metroData[i][1]);
      temp1.add(metroData[i][2]);
      temp1.add(metroData[i][3]);
      markersList.add(temp1);
      LatLng position =
          LatLng(double.parse(metroData[i][2]), double.parse(metroData[i][3]));
      _markers.add(
        Marker(
          markerId: MarkerId(metroData[i][1]),
          position: position,
          infoWindow: InfoWindow(title: metroData[i][1]),
        ),
      );
    }

    Navigator.pop(context);
    setState(() {});
  }

  Future getCurrentLocation() async {
    late LocationData locationData;
    Location location = Location();
    try {
      locationData = await location.getLocation();
    } catch (e) {}
    return LatLng(
        locationData.latitude!.toDouble(), locationData.longitude!.toDouble());
  }
}
