import 'package:flutter/material.dart';
import 'package:metro_mate/MainScreen/Home/FAQandSupportPage.dart';
import 'package:metro_mate/MainScreen/Home/Drawer/SelectCityPage.dart';
import 'package:metro_mate/MainScreen/Home/Drawer/TermsofUsagePage.dart';
import 'package:metro_mate/Variables.dart';
import 'package:metro_mate/MainScreen/Home/Drawer/WalletPage.dart';

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
            child: const Padding(
              padding: EdgeInsets.all(10.0),
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
                    builder: (context) => const WalletPage(),
                  ));
            },
            child: const ListTile(
              leading: Icon(Icons.account_balance_wallet),
              title: Text("Wallet"),
              trailing: Text("₹ 0.0"),
            ),
          ),
          Box("Change City", Icons.pin_drop_outlined,SelectCityPage(currentCity: selectedCity.toString(),)),
          Box("Terms of Usage", Icons.article_outlined,const TermsofUsagePage()),
          Box("FAQs & Support", Icons.info_outlined,const FAQandSupportPage()),
        ],
      ),
    );
  }
  Box(String titile,IconData icon,nextPage){
    return InkWell(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => nextPage,
            ));
      },
      child: ListTile(
        leading: Icon(icon),
        title: Text(titile),
      ),
    );
  }
}
