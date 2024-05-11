//This file contain the whole code for notifications

import 'dart:io';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebasenotifications/Screens/notification_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notifications {

  //Firebase Messaging instance
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  //Firebase init
  //It will show the notification details.....For showing the notification in app we will use local notification package

  //Flutter Local Notification Instance for showing the message in frontend

  //Notification Channels: Useful because it make a group of messages which is received by another devices.

  final flutter_local_notification = FlutterLocalNotificationsPlugin();

  void initLocalNotification(
      BuildContext context, RemoteMessage message) async {
    //If you wanna to add your icon/image then add it inside the drawable folder and make it smallest!!

    var initializationSettingsAndroid =
    new AndroidInitializationSettings('@mipmap/ic_launcher');

    var IOSIntializationSettings = const DarwinInitializationSettings();

    var initialzation_Setting = InitializationSettings(
        android: initializationSettingsAndroid, iOS: IOSIntializationSettings);

    await flutter_local_notification.initialize(initialzation_Setting,
        onDidReceiveNotificationResponse: (payload) {
      handleMessage(context, message);
        });
  }

  Future<void> showNotification(RemoteMessage message) async {

    AndroidNotificationChannel androidChannel = AndroidNotificationChannel(
        Random.secure().nextInt(10000).toString(),
        'High Importance Notifications',
        importance: Importance.max);

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            androidChannel.id.toString(), androidChannel.name.toString(),
            importance: Importance.high,
            priority: Priority.high,
            ticker: 'ticker');

    const DarwinNotificationDetails IOSNotificationsDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: IOSNotificationsDetails);

    Future.delayed(Duration.zero, () {
      flutter_local_notification.show(0, message.notification!.title.toString(),
          message.notification!.body.toString(), notificationDetails);
    });

  }

  void firebaseInit(BuildContext context){

    FirebaseMessaging.onMessage.listen((message) {

      RemoteNotification? notification = message.notification ;
      AndroidNotification? android = message.notification!.android ;

      if (kDebugMode) { //Not run we we use the APK of an app it will make our app faster.
        print("notifications title:${notification!.title}");
        print("notifications body:${notification.body}");
        print('count:${android!.count}');
        print('data:${message.data.toString()}');
        print("Payload data is :");
        print("Type is ${message.data['type']}");
        print("ID is ${message.data['id']}");
      }

      if(Platform.isIOS){
        forgroundMessage();
      }

      if(Platform.isAndroid){
        initLocalNotification(context, message);
        showNotification(message);
      }

    });
  }

  //For IOS-Extra We will do some settings in Xcode, Developers Account & in Firebase console for IOS Devices.
  Future forgroundMessage() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }


  //Method For showing the message screen one we click on the notification message:
  /*
  * Set the payload from firebase console where set type/id then from flutterlocalnontification method - payload property we
  * will access it and called our below method from the above(flutterlocalnontification) method:
   */

  void handleMessage(BuildContext context,RemoteMessage message)
  {
    if(message.data['type'] == 'message')
      {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>notification_Screen()));
      }
  }

  Future<void> setupInteractMessage(BuildContext context) async
  {
    //When app is exit/terminated

    RemoteMessage? initial_message = await FirebaseMessaging.instance.getInitialMessage();

    if(initial_message!=null)
      {
        handleMessage(context, initial_message);
      }

    //When app is in background

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });



  }


  //Method for permission
  void request() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      sound: true,
      badge: true,
      //provisional: true, If it is true then it automatically allow the permission.
      carPlay: true,
      announcement: true,
      criticalAlert: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("Permission Authorized");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("Permission is not Authorized But it will be redirect");
    } else {
      print("Permission is denied");
    }
  }

/*
  Device Token:
               Each device(mobile) consist of their token id which is used by Firebase for
  sending the messages to device(mobile).

  *If the allocated device token is expired due to any reasons then we will refresh the device token
  for generating another device token.

*/

  Future<String?> getTokenId() async {
    String? token_id = await messaging.getToken();
   // print("Token ID = ${token_id}");
    return await messaging.getToken();
  }

  void refreshedToken() {
    messaging.onTokenRefresh.listen((event) {
      print("Token Refreshed");
      print(event.toString());
    });
  }



  /*
  Sending messages from one device to another:
                                              Firstly visit to firebase console>project settings>make server key in cloud messaging tab..
  Then, using the server id we will send the messages from one device to another device, so import HTTP package in your project.
  Fetch the token id and then using future method add/fill the details for sending the notification to another device.

  OR

  Same procedure we will also done it from POSTMAN paste the url in the postman url bar.
  and add the headers and body to it.
   */
}
