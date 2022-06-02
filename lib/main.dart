// ignore_for_file: prefer_const_constructors

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:go_haul/dashboard.dart';
import 'package:go_haul/splashScreen.dart';
import 'package:go_haul/utils/extension.dart';

import 'authController.dart';
import 'cargoGenerator.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    Get.put(CargoGenController());
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return GetMaterialApp(
        debugShowCheckedModeBanner: false, home: SplashScreen());
  }
}

class ScreensController extends StatefulWidget {
  @override
  State<ScreensController> createState() => _ScreensControllerState();
}

class _ScreensControllerState extends State<ScreensController> {
  final Future<SharedPreferences> _preferences =
      SharedPreferences.getInstance();
  String? token;
  a() async {
    await _preferences.then((SharedPreferences p) {
      if (p.getString("UID") != null) {
        setState(() {
          token = p.getString("UID") as String;
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    a();
  }

  @override
  Widget build(BuildContext context) {
    final userAuth = Get.put(Auth.initialize());
    Get.put(Auth);
    if (token != null) {
      Get.find<Auth>().userData = token;
      return Dashboard();
    } else {
      return SignInPage();
    }
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  var androiInit = AndroidInitializationSettings('@mipmap/ic_launcher');

  var iosInit = IOSInitializationSettings();

  var initSetting = InitializationSettings(android: androiInit, iOS: iosInit);

  FlutterLocalNotificationsPlugin fltNotification =
      FlutterLocalNotificationsPlugin();

  fltNotification.initialize(initSetting);
  var androidDetails = AndroidNotificationDetails('1', 'channelName',
      channelDescription: 'channel Description');

  var iosDetails = IOSNotificationDetails();

  var generalNotificationDetails =
      NotificationDetails(android: androidDetails, iOS: iosDetails);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      fltNotification.show(notification.hashCode, notification.title,
          notification.body, generalNotificationDetails);
    }
  });

  print("Handling a background message: ${message.messageId}");
}
