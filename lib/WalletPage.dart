import 'package:flutter/material.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Wallet"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              Column(
                children: [
                  Text("Total Balance",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 20),),
                  Text("₹ 0.0",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 20)),
                  ElevatedButton(
                      onPressed: (){
                      },
                      child: Text("Add Cash")
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
