import 'dart:async';
import 'dart:ui' as ui;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:metro_mate/Variables.dart';
import 'package:qr_flutter/qr_flutter.dart';
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
  final _imgkey = GlobalKey<FormState>();
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
        title: Text("QR Ticket"),
        elevation: 0,
        actions: [
          IconButton(onPressed: () async{
            await download();
          }, icon: Icon(Icons.download)),
          IconButton(onPressed: () async{
            await share();
          }, icon: Icon(Icons.share)),
        ],
      ),
        body:RepaintBoundary(
          child: Center(
            child: RepaintBoundary(
              key: _imgkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Ahemdabad Metro",style: TextStyle(fontSize:20,fontWeight: FontWeight.bold),),
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
        )
    );
  }

  StoreTicket() async{
    RenderRepaintBoundary? boundary = _imgkey.currentContext!.findRenderObject() as RenderRepaintBoundary?;
    ui.Image image = await boundary!.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    final storageRef = FirebaseStorage.instance.ref().child(
        'Tickets/${widget.city}/${widget.bookingId}');
    ref=await storageRef.getDownloadURL();
    print("???????????????????????????????????????????????????????????????");
    print(storageRef.getDownloadURL());
    print(ref);
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
  }

  Future download() async{
    Loading(context);
    RenderRepaintBoundary boundary = _imgkey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData =
    await (image.toByteData(format: ui.ImageByteFormat.png));
    await ImageGallerySaver.saveImage(byteData!.buffer.asUint8List());
    Navigator.pop(context);
  }

  Future share() async{
    // Loading(context);
    // RenderRepaintBoundary boundary = _imgkey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    // ui.Image image = await boundary.toImage();
    // ByteData? byteData = await (image.toByteData(format: ui.ImageByteFormat.png));
    // Navigator.pop(context);
    await Share.share(
      "QR Ticket \n $ref",
    );
  }
}


