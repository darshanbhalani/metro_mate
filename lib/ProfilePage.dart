import 'package:flutter/material.dart';
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
        title: Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
        child: Column(
          children: [
            CircleAvatar(
              radius: 100,
            ),
            SizedBox(width: 15),
            ShowField("Name", "Darshan Bhalani", true),
            ShowField("Phone No", "9909343073", true),
            SizedBox(height: 20,),
            InkWell(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: PrimaryColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.logout,color: Colors.white),
                      SizedBox(width: 5),
                      Text("LogOut",style: TextStyle(color: Colors.white),),
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
