import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:metro_mate/Variables.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

class TicketViewPage extends StatefulWidget {
  final String city;
  final String phone;
  final String qrData;
  final String source;
  final String destination;
  final String bookingDate;
  final String bookingTime;
  final String numberOfTickets;
  final String totalFare;
  final String bookingId;

  const TicketViewPage({super.key,required this.city,required this.phone,required this.qrData,required this.source,required this.destination,required this.bookingTime,required this.bookingDate,required this.numberOfTickets,required this.totalFare,required this.bookingId});

  @override
  State<TicketViewPage> createState() => _TicketViewPageState();
}

class _TicketViewPageState extends State<TicketViewPage> {

  final ScreenshotController screenshotController = ScreenshotController();
  final _imgkey = GlobalKey<FormState>();
  Uint8List? screenshotImageBytes;
  var ref;

  @override
  void initState(){
    Timer(const Duration(seconds: 1),(){
      StoreTicket();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PrimaryColor,
        title: const Text("QR Ticket"),
        elevation: 0,
        actions: [
          IconButton(onPressed: () async{
            await download();
          }, icon: const Icon(Icons.download)),
          IconButton(onPressed: () async{
            await share();
          }, icon: const Icon(Icons.share)),
        ],
      ),
        body:Screenshot(
          controller: screenshotController,
          child: Container(
            color: Colors.white,
            child: Center(
              child: RepaintBoundary(
                key: _imgkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                       Text("$selectedCity Metro",style: const TextStyle(fontSize:20,fontWeight: FontWeight.bold),),
                      QrImageView(
                        data: widget.qrData,
                        version: QrVersions.auto,
                        size: 250,
                      ),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.black, fontSize: 36),
                          children: <TextSpan>[
                            TextSpan(text: '${widget.source} ', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'to '),
                            TextSpan(text:'${widget.destination} ', style: const TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                        textScaleFactor: 0.5,
                      ),
                      const SizedBox(height: 5,),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.black, fontSize: 36),
                          children: <TextSpan>[
                            const TextSpan(text: 'Booking Date :- ', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: widget.bookingDate),
                          ],
                        ),
                        textScaleFactor: 0.5,
                      ),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.black, fontSize: 36),
                          children: <TextSpan>[
                            const TextSpan(text: 'Booking Time :- ', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: widget.bookingTime),
                          ],
                        ),
                        textScaleFactor: 0.5,
                      ),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.black, fontSize: 36),
                          children: <TextSpan>[
                            const TextSpan(text: 'Number of Tickets :- ', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: widget.numberOfTickets),
                          ],
                        ),
                        textScaleFactor: 0.5,
                      ),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.black, fontSize: 36),
                          children: <TextSpan>[
                            const TextSpan(text: 'Total Fare ', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: widget.totalFare),
                          ],
                        ),
                        textScaleFactor: 0.5,
                      ),
                    ],
                  ),
              ),
            ),
          ),
        )
    );
  }

  StoreTicket() async{
    Loading(context);
    RenderRepaintBoundary? boundary = _imgkey.currentContext!.findRenderObject() as RenderRepaintBoundary?;
    ui.Image image = await boundary!.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    final storageRef = FirebaseStorage.instance.ref().child(
        'Tickets/${widget.city}/${widget.bookingId}');
    // ref=await storageRef.getDownloadURL();
    storageRef.putData(pngBytes).whenComplete(() async {
      final ticketUrl = await FirebaseStorage.instance
          .ref()
          .child(
          'Tickets/${widget.city}/${widget.bookingId}')
          .getDownloadURL();
      fire.collection("Tickets").doc(widget.bookingId).set({
        "Booking Id":widget.bookingId,
        "Source":widget.source,
        "Destination":widget.destination,
        "Booking Time":widget.bookingTime,
        "Booking Date":widget.bookingDate,
        "Number of Tickets":widget.numberOfTickets,
        "Total Fare":widget.totalFare,
        "Phone No":widget.phone,
        "Metro":widget.city,
        "QR Ticket":ticketUrl.toString(),
        "DateTime":DateTime.now()
      });
    });
    Navigator.pop(context);
  }

  download() async{
    Loading(context);
    if(screenshotImageBytes == null){
      final Uint8List? imageBytes = await screenshotController.capture();
      setState(() {
        screenshotImageBytes = imageBytes;
      });
    }
    setState(() {});
    await ImageGallerySaver.saveImage(screenshotImageBytes!);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Ticket Saved Succesfully"),
    ));
  }

  Future share() async {
    Loading(context);
    if(screenshotImageBytes == null){
      final Uint8List? imageBytes = await screenshotController.capture();
      setState(() {
        screenshotImageBytes = imageBytes;
      });
    }
    setState(() {});
    final tempDir = Directory.systemTemp;
    final file = File('${tempDir.path}/$selectedCity Metro Ticket.png');
    file.writeAsBytesSync(screenshotImageBytes!);
    Share.shareFiles([file.path], text: "$selectedCity Metro Ticket");
    Navigator.pop(context);
  }
}


