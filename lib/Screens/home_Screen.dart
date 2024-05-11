import 'dart:convert';
import 'package:flutter/material.dart';
import 'notifications.dart';
import 'package:http/http.dart' as http;

class home_Screen extends StatefulWidget {
  const home_Screen({super.key});

  @override
  State<home_Screen> createState() => _home_ScreenState();
}

class _home_ScreenState extends State<home_Screen> {

  Notifications notify = Notifications();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //Requesting for notifications permission
    notify.request();

    //Getting Token Id
    notify.getTokenId();

    //Refreshing the Token ID If expired
    notify.refreshedToken();

    //Calling Firebase init method
    notify.firebaseInit(context);

    //Calling the method for showing the message in background or in terminated state.
    notify.setupInteractMessage(context);

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("HOME SCREEN",style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.w500),),
        centerTitle: true,
      ),
      body:   Padding(
        padding: const EdgeInsets.only(left: 50,right: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("HELLO!!",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w800),),
            const Text("HERE YOU WILL SEE THE RECEIVING NOTIFICATIONS",style: TextStyle(color: Colors.black,fontSize: 10,fontWeight: FontWeight.w500),),
            const Text("OR",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w800),),
            InkWell(
              onTap: (){
                //Getting token id in which we will send the notification:
                print('ontap');
                notify.getTokenId().then((value)async{

                  print('inside future method-TOKEN ID : ${value}');

                  var data = {
                    'to' : value.toString(), //use another device tokenid for sending the message to another device(Here we will send the notification to current device in which app is running)
                    'notification' : {
                      'title' : 'OWN NOTIFICATION' ,
                      'body' : 'BODY OF THE NOTIFICATION' ,
                    },
                    'type':{
                      'type':'message',
                      'id':'12',
                    }
                  };

                  await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
                      body: jsonEncode(data) ,
                      headers: {
                        'Content-Type': 'application/json; charset=UTF-8',
                        'Authorization' : 'AAAA7BHIB9g:APA91bF8gm22IP57fs3fMD9wkkADK5KpY2YSISElHyHVSv74_pSoWnOAML_QcZWEDIUsx4-bNQt0ip8GtzDEr2VAtSpOIwS1KITmXF0jwkB92O5oG6vnHQRYHshQ7zMEZtZ8sernw60Z'
                      }
                  );

                });
              },
                child: const Text("SEND NOTIFICATION",
                  style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w800,decoration: TextDecoration.underline),)),
          ],
        ),
      ),
    );
  }
}
