
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
  List<Map<String, dynamic>> markerData = [
    // {'name': 'Marker 1', 'lat': 23.255411, 'lng': 72.639467},
    // {'name': 'Marker 2', 'lat': 23.075117495076167, 'lng': 72.5932850243894},
    // Add more markers as needed
  ];

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
        onMapCreated: (controller) {
          getCurrentLocation();
          getData();
          setState(() {});
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(
              StationPosition["${selectedCity}X"]!,StationPosition["${selectedCity}Y"]!), // Initial map location
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
          onPressed: () {  },
          backgroundColor: Colors.transparent,
          label:Container(
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
                  itemBuilder: (BuildContext context, int index){
                    // var d = calculateDistance(
                    //     userLocationX,
                    //     markersList[index][1],
                    //     userLocationY,
                    //     markersList[index][2]);

                   double  d = Geolocator.distanceBetween(
                        userLocationX,
                        double.parse(markersList[index][1]),
                        userLocationY,
                       double.parse(markersList[index][2]));
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 50,
                          child: GestureDetector(
                            onTap: () async {
                              await openGoogleMap(markersList[index][0]+" "+selectedCity);
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
                              trailing: Text("${d.toStringAsFixed(0)}m"),
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
    // LatLng(locationData.latitude!.toDouble(), locationData.longitude!.toDouble());
    userLocationX = locationData.latitude!.toDouble();
    userLocationY = locationData.longitude!.toDouble();
    _markers.add(Marker(
      infoWindow: const InfoWindow(title: "Your Location"),
      markerId: const MarkerId("Your Location"),
      position: LatLng(locationData.latitude!.toDouble(),
          locationData.longitude!.toDouble()),
      icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueGreen
      ),
    ));
    for(int i = 0; i < metroData.length; i++){
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
