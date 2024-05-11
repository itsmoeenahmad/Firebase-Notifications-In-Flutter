import 'package:flutter/material.dart';

class notification_Screen extends StatefulWidget {
  const notification_Screen({super.key});

  @override
  State<notification_Screen> createState() => _notification_ScreenState();
}

class _notification_ScreenState extends State<notification_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("NOTIFICATION SCREEN",style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.w500),),
        centerTitle: true,
      ),
      body:  const Padding(
        padding: EdgeInsets.only(left: 50,right: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("NOTIFICATIONS RECEIVED!!!",style: TextStyle(color: Colors.black,fontSize: 10,fontWeight: FontWeight.w500),),
          ],
        ),
      ),
    );
  }
}
