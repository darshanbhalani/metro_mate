import 'package:flutter/material.dart';
import 'package:metro_mate/Variables.dart';
import 'package:photo_view/photo_view.dart';

class MetroMapPage extends StatefulWidget {
  final String city;
  const MetroMapPage({Key? key,required this.city}) : super(key: key);

  @override
  State<MetroMapPage> createState() => _MetroMapPageState();
}

class _MetroMapPageState extends State<MetroMapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: PrimaryColor,
        title: Text("${widget.city} Metro Map"),
      ),
      body: Container(
        color: Colors.transparent,
        child: PhotoView(
          initialScale: PhotoViewComputedScale.covered,
          basePosition: Alignment.center,
          minScale: PhotoViewComputedScale.covered,
          imageProvider:
          AssetImage("assets/images/maps/${widget.city}MetroMap.png"),
        ),
      ),
    );
  }
}
