import 'package:flutter/material.dart';
import 'package:metro_mate/MainScreen/Home/TicketBooking/TicketViewPage.dart';
import 'package:metro_mate/Variables.dart';
import 'package:upi_india/upi_india.dart';

class UPIPaymentPage extends StatefulWidget {
  final String amount;
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
  const UPIPaymentPage({super.key,required this.amount,required this.city,required this.phone,required this.qrData,required this.source,required this.destination,required this.bookingTime,required this.bookingDate,required this.numberOfTickets,required this.totalFare,required this.bookingId});


  @override
  State<UPIPaymentPage> createState() => _UPIPaymentPageState();
}

class _UPIPaymentPageState extends State<UPIPaymentPage> {
  Future<UpiResponse>? _transaction;
  UpiIndia _upiIndia = UpiIndia();
  List<UpiApp>? apps;

  TextStyle header = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  TextStyle value = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );

  @override
  void initState() {
    _upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
      setState(() {
        apps = value;
      });
    }).catchError((e) {
      apps = [];
    });
    super.initState();
  }

  Future<UpiResponse> initiateTransaction(UpiApp app) async {
    return _upiIndia.startTransaction(
      app: app,
      receiverUpiId: "darshanbhalanipatel@oksbi",
      receiverName: 'Metro Mate',
      transactionRefId: 'Metro Mate',
      amount: double.parse(widget.amount),
    );
  }

  Widget displayUpiApps() {
    if (apps == null)
      return Center(child: CircularProgressIndicator());
    else if (apps!.length == 0)
      return Center(
        child: Text(
          "No apps found to handle transaction.",
          style: header,
        ),
      );
    else
      return Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Wrap(
            children: apps!.map<Widget>((UpiApp app) {
              return GestureDetector(
                onTap: () {
                  _transaction = initiateTransaction(app);
                  setState(() {});
                },
                child: Container(
                  height: 100,
                  width: 100,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.memory(
                        app.icon,
                        height: 60,
                        width: 60,
                      ),
                      Text(app.name),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
  }

  String _upiErrorHandler(error) {
    switch (error) {
      case UpiIndiaAppNotInstalledException:
        return 'Requested app not installed on device';
      case UpiIndiaUserCancelledException:
        return 'You cancelled the transaction';
      case UpiIndiaNullResponseException:
        return 'Requested app didn\'t return any response';
      case UpiIndiaInvalidParametersException:
        return 'Requested app cannot handle the transaction';
      default:
        return 'An Unknown error has occurred';
    }
  }

  void _checkTxnStatus(String status) {
    switch (status) {
      case UpiPaymentStatus.SUCCESS:
        print('Transaction Successful');
        break;
      case UpiPaymentStatus.SUBMITTED:
        print('Transaction Submitted');
        break;
      case UpiPaymentStatus.FAILURE:
        print('Transaction Failed');
        break;
      default:
        print('Received an Unknown transaction status');
    }
  }

  Widget displayTransactionData(title, body) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$title: ", style: header),
          Flexible(
              child: Text(
                body,
                style: value,
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PrimaryColor,
        title: Text('Available UPI Apps'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: displayUpiApps(),
          ),
        ],
      ),
    );
  }
}
