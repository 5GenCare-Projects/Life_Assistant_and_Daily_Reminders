import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'home.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'message.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Initialize the binding for the Flutter app
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final notificationSettings =
      await FirebaseMessaging.instance.requestPermission(provisional: true);
  final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
  if (apnsToken != null) {}
  FirebaseMessaging.instance.onTokenRefresh
      .listen((fcmToken) {})
      .onError((err) {});
  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final LocalNotifications localNotifications = LocalNotifications();

  @override
  Widget build(BuildContext context) {
    localNotifications.initializeNotifications();
    localNotifications.setupFirebaseMessaging();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gradient Background',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
      },
    );
  }
}
