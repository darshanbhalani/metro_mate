import 'package:flutter/material.dart';
import 'package:metro_mate/LogIn/MainPage.dart';
import 'package:metro_mate/MainScreen/Home/Drawer/DrawerPage.dart';
import 'package:metro_mate/Variables.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PrimaryColor,
        title: const Text("Profile"),
      ),
      drawer: DrawerPage(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          children: [
            CircleAvatar(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  image: DecorationImage(
                    image: AssetImage("assets/images/UserProfile.jpg")
                  ),
                ),
              ),
              radius: 80,
            ),
            const SizedBox(width: 15),
            ShowField("Name", "$cuFName $cuLName", false),
            ShowField("Phone No", cuPhone, false),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                logOut(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: PrimaryColor,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.logout, color: Colors.white),
                      SizedBox(width: 5),
                      Text(
                        "LogOut",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

logOut(context) {
  return showDialog(context: context, builder: (context) => AlertDialog(
    title: const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.logout),
        SizedBox(width: 5,),
        Text("Sign Out"),
      ],
    ),
    content: const Text("sure you want to Sign Out ?"),
    actions: [
      TextButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: const Text("No")),
      TextButton(
          onPressed: () async {
            Loading(context);
            cardList=[];
            metroStationsList = [];
            metroGraph = {};
            stationList=[];
            fareMatrix=[];
            stationLineColor= {};
            await auth.signOut();
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const MainPage()), (route) => false);
          },
          child: const Text("Yes"))
    ],
  ));
}
