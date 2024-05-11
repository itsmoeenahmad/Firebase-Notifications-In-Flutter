import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'Screens/home_Screen.dart';


@pragma('vm:entry-point') //Method for showing the background notification: It will be popup when you fill all the requirements in firebase console for messaging.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message)async {
  await Firebase.initializeApp();
}


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
        title: 'Firebase Notifications Learning',
      home: home_Screen(),
    );
  }
}
