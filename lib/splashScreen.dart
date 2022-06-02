import 'package:flutter/material.dart';
import 'package:go_haul/authController.dart';
import 'package:go_haul/dashboard.dart';
import 'package:go_haul/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './utils/extension.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  @override
  Widget build(BuildContext context) {
    final userAuth = Get.put(Auth.initialize());
    Get.put(Auth);
    return Scaffold(
        body: SizedBox(
            height: context.deviceHeight,
            width: context.deviceWidth,
            child: Image.asset(
              "images/splash_screen.png",
              fit: BoxFit.fill,
            )));
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () async {
      final SharedPreferences prefs = await _prefs;
      print(prefs.getString("UID"));
      if (prefs.getString("UID") != null) {
        Get.find<Auth>().userData = prefs.getString("UID");
        Get.offAll(Dashboard());
      } else {
        Get.offAll(SignInPage());
      }
    });
  }
}
