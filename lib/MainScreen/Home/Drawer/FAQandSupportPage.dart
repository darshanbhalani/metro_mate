import 'package:flutter/material.dart';
import 'package:metro_mate/Variables.dart';

class FAQandSupportPage extends StatefulWidget {
  const FAQandSupportPage({Key? key}) : super(key: key);

  @override
  State<FAQandSupportPage> createState() => _FAQandSupportPageState();
}

class _FAQandSupportPageState extends State<FAQandSupportPage> {
  int? flag;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FAQ & Support"),
        backgroundColor: PrimaryColor,
      ),
      body: ListView.builder(
        itemCount: FAQ.length,
        itemBuilder: (context, index) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: (){
                  if(flag!=index){
                    flag=index;
                  }
                  else{
                    flag=null;
                  }
                  setState(() {});
                },
                child: ListTile(
                  title: Text(FAQ[index][0]),
                  trailing: flag==index ? Icon(Icons.arrow_drop_up):Icon(Icons.arrow_drop_down),
                  subtitle: flag==index ? Text("\n"+FAQ[index][1]+"\n"):null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Divider(thickness: 1,),
              )
            ],
          );
        },
      ),
    );
  }
}
