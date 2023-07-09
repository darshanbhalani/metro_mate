import 'package:flutter/material.dart';
import 'package:metro_mate/FAQandSupportPage.dart';
import 'package:metro_mate/PrivatePolicyPage.dart';
import 'package:metro_mate/SelectCityPage.dart';
import 'package:metro_mate/SettingsPage.dart';
import 'package:metro_mate/TermsofUsagePage.dart';
import 'package:metro_mate/Variables.dart';
import 'package:metro_mate/WalletPage.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({Key? key}) : super(key: key);

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            color: SecondryColor,
            height: 180,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 45,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Darshan Bhalani",style: TextStyle(
                          fontSize: 25
                        ),)
                      ],
                    ),
                  )
                ],
              ),
            )
          ),
          InkWell(
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WalletPage(),
                  ));
            },
            child: ListTile(
              leading: Icon(Icons.account_balance_wallet),
              title: Text("Wallet"),
              trailing: Text("₹ 0.0"),
            ),
          ),
          Box("Change City", Icons.pin_drop_outlined,SelectCityPage(currentCity: selectedCity.toString(),)),
          Box("Private Policy", Icons.article_outlined,PrivatePolicyPage()),
          Box("Terms of Usage", Icons.file_copy_rounded,TermsofUsagePage()),
          Box("FAQs & Support", Icons.info_outlined,FAQandSupportPage()),
        ],
      ),
    );
  }
  Box(String _titile,IconData _icon,_nextPage){
    return InkWell(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => _nextPage,
            ));
      },
      child: ListTile(
        leading: Icon(_icon),
        title: Text(_titile),
      ),
    );
  }
}
