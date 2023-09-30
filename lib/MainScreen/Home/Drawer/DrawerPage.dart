import 'package:flutter/material.dart';
import 'package:metro_mate/MainScreen/Home/Drawer/FAQandSupportPage.dart';
import 'package:metro_mate/MainScreen/Home/Drawer/SelectCityPage.dart';
import 'package:metro_mate/MainScreen/Home/Drawer/TermsofUsagePage.dart';
import 'package:metro_mate/Variables.dart';
import 'package:metro_mate/MainScreen/Home/Drawer/WalletPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({Key? key}) : super(key: key);

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}


class _DrawerPageState extends State<DrawerPage> {
  double? cureentBalance;




  fatchCurrntBalance(){
    fire.collection('Users').doc(cuPhone).get().then((value) {
      cureentBalance=double.parse(value["Photo"]);
    }).whenComplete(() async{
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString("cuPhoto", cureentBalance.toString());
      setState(() {
      });
    });
  }

  @override
  void initState() {
    fatchCurrntBalance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            color: PrimaryColor,
            height: 180,
            child:Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  CircleAvatar(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          image: const DecorationImage(
                              image: AssetImage("assets/images/UserProfile.jpg")
                          )
                      ),
                    ),
                    radius: 50,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("$cuFName $cuLName",style: const TextStyle(
                          fontSize: 25
                        ),)
                      ],
                    ),
                  )
                ],
              ),
            )
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WalletPage(),
                  ));
            },
            child: ListTile(
              leading: Icon(Icons.account_balance_wallet),
              title: Text("Wallet"),
              trailing: Text("₹ ${cureentBalance ?? 0.0}"),
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
    return GestureDetector(
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
