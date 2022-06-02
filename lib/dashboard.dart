// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_haul/authController.dart';
import 'package:go_haul/cargoGenerator.dart';
import 'package:go_haul/current_location.dart';
import 'package:go_haul/login.dart';
import 'package:go_haul/profile.dart';
import 'package:go_haul/utils/extension.dart';
import 'package:intl/intl.dart';

import 'history.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({
    Key? key,
  }) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var details;
  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();
  int type = 1;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  TextEditingController _nameCont = TextEditingController();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin? fltNotification;
  void getToken() async {
    String? a = await messaging.getToken();

    FirebaseFirestore.instance
        .collection("users")
        .doc(Get.find<Auth>().userData)
        .update({'token': a.toString()});
  }

  void initMessaging() {
    var androiInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    var iosInit = IOSInitializationSettings();

    var initSetting = InitializationSettings(android: androiInit, iOS: iosInit);

    fltNotification = FlutterLocalNotificationsPlugin();

    fltNotification!.initialize(initSetting);
    var androidDetails = AndroidNotificationDetails('1', 'channelName',
        channelDescription: 'channel Description');

    var iosDetails = IOSNotificationDetails();

    var generalNotificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        fltNotification!.show(notification.hashCode, notification.title,
            notification.body, generalNotificationDetails);
      }
      //    var androidDetails =
      //     AndroidNotificationDetails('1', 'channelName', 'channel Description');

      // var iosDetails = IOSNotificationDetails();

      // var generalNotificationDetails =
      //     NotificationDetails(android: androidDetails, iOS: iosDetails);

      // await fltNotification.show(0, 'Rsafe', 'Service Provider', generalNotificationDetails,
      //     payload: 'Notification');
    });
  }

  void notitficationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    details = FirebaseFirestore.instance
        .collection("users")
        .doc(Get.find<Auth>().userData as String);

    getToken();
    notitficationPermission();
    initMessaging();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(Auth);
    Get.put(CargoGenController());
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.green,
          title: Image.asset(
            "images/logo.png",
            height: 50,
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Get.to(Profile());
                },
                icon: Icon(Icons.person)),
            IconButton(
                onPressed: () {
                  Get.to(History());
                },
                icon: Icon(Icons.history)),
            IconButton(
                onPressed: () async {
                  await preferences.then((value) => value.remove("UID"));
                  Get.offAll(SignInPage());
                },
                icon: Icon(Icons.logout)),
          ],
        ),
        body: FutureBuilder<DocumentSnapshot>(
          future: details.get(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              final _data = snapshot.data!;
              return ListView(
                padding: const EdgeInsets.all(30),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _vehicle("Bus", FontAwesomeIcons.bus, 20, 1),
                      _vehicle("Truck", FontAwesomeIcons.truck, 20, 2),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _vehicle("Car", FontAwesomeIcons.car, 20, 3),
                      _vehicle("Pickup", FontAwesomeIcons.truckPickup, 20, 4),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  OutlinedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              AppColors.green.withOpacity(0.1))),
                      onPressed: () async {
                        if (_data['verified'] == true) {
                          final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              initialDatePickerMode: DatePickerMode.day,
                              firstDate: DateTime(2022),
                              lastDate: DateTime(2101));
                          if (picked != null) {
                            setState(() {
                              selectedDate = picked;
                            });
                            final TimeOfDay? picked2 = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (picked2 != null)
                              // ignore: curly_braces_in_flow_control_structures
                              setState(() {
                                selectedTime = picked2;
                              });
                          }
                          Get.find<CargoGenController>().dateTime = DateTime(
                              selectedDate!.year,
                              selectedDate!.month,
                              selectedDate!.day,
                              selectedTime!.hour,
                              selectedTime!.minute);
                          Get.bottomSheet(_SelectOptions());
                        } else {
                          Get.snackbar("Unverified", "Contact Admin",
                              snackPosition: SnackPosition.BOTTOM);
                        }
                      },
                      child: text("SELECT", textColor: AppColors.green))
                ],
              );
            }
          },
        ));
  }

  Widget _vehicle(String label, IconData iconData, int weight, int numb) {
    return GestureDetector(
      onTap: () {
        setState(() {
          type = numb;
        });
        Get.find<CargoGenController>().cargoType = label;
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: boxDecoration(
          radius: 15,
          bordercolor: numb == type ? AppColors.green : AppColors.white,
        ),
        width: 100,
        height: 100,
        child: Column(children: [
          text(label),
          Icon(
            iconData,
            size: 20,
          ),
          text("$weight kg max")
        ]),
      ),
    );
  }
}

class _SelectOptions extends StatefulWidget {
  const _SelectOptions({Key? key}) : super(key: key);

  @override
  State<_SelectOptions> createState() => __SelectOptionsState();
}

class __SelectOptionsState extends State<_SelectOptions> {
  int val = 1;
  @override
  Widget build(BuildContext context) {
    Get.put(CargoGenController());
    return Container(
      height: context.deviceHeight * 0.2,
      color: AppColors.white,
      child: Column(
        children: [
          ListTile(
            title: Text("Full Day for Rs. 8000"),
            leading: Radio(
              value: 1,
              groupValue: val,
              onChanged: (value) {
                setState(() {
                  val = value as int;
                });
              },
              activeColor: Colors.green,
            ),
          ),
          ListTile(
            title: Text("Half Day for Rs. 4000"),
            leading: Radio(
              value: 2,
              groupValue: val,
              onChanged: (value) {
                setState(() {
                  val = value as int;
                });
              },
              activeColor: Colors.green,
            ),
          ),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(AppColors.green)),
              onPressed: () {
                Get.find<CargoGenController>().price = val == 1 ? 8000 : 4000;
                print(Get.find<CargoGenController>().price);
                Get.to(UserLocation());
              },
              child: Text("CONFIRM")),
        ],
      ),
    );
  }
}
