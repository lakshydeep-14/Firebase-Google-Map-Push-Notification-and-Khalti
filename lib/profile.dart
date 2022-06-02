import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_haul/cargoGenerator.dart';
import 'package:go_haul/utils/colors.dart';
import 'package:go_haul/utils/global_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'authController.dart';
import 'dashboard.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var details = FirebaseFirestore.instance
      .collection("users")
      .doc(Get.find<Auth>().userData as String);
  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();
  int type = 1;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  TextEditingController _nameCont = TextEditingController();
  TextEditingController _emailCont = TextEditingController();
  TextEditingController _pwdCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Get.put(Auth);
    Get.put(CargoGenController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.green,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.offAll(Dashboard()),
        ),
        title: text("Profile",
            textColor: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25.0),
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
                  children: [
                    text("UserId:  "),
                    text(Get.find<Auth>().userData as String,
                        fontWeight: FontWeight.w400),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    text("Status:  "),
                    text(_data["verified"] ? "Verified" : "Unverified"),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    text("Name:  "),
                    Expanded(
                      child: textInputContainer(
                          hint: _data["name"],
                          textEditingController: _nameCont,
                          inputType: TextInputType.name,
                          validator: (value) {}),
                    ),
                    IconButton(
                        onPressed: () async {
                          details.update({"name": _nameCont.text});
                          Get.snackbar("Successful", "Name Changed",
                              snackPosition: SnackPosition.BOTTOM);
                        },
                        icon: Icon(Icons.save)),
                  ],
                ),
                Row(
                  children: [
                    text("Email:  "),
                    Expanded(
                      child: textInputContainer(
                          hint: _data["email"],
                          textEditingController: _emailCont,
                          inputType: TextInputType.name,
                          validator: (value) {}),
                    ),
                    IconButton(
                        onPressed: () async {
                          details.update({"email": _emailCont.text});
                          Get.snackbar("Successful", "Email Changed",
                              snackPosition: SnackPosition.BOTTOM);
                        },
                        icon: Icon(Icons.save)),
                  ],
                ),
                Row(
                  children: [
                    text("Password:  "),
                    Expanded(
                      child: textInputContainer(
                          obscure: true,
                          hint: _data["pwd"],
                          textEditingController: _pwdCont,
                          inputType: TextInputType.name,
                          validator: (value) {}),
                    ),
                    IconButton(
                        onPressed: () async {
                          details.update({"pwd": _pwdCont.text});
                          Get.snackbar("Successful", "Password Changed",
                              snackPosition: SnackPosition.BOTTOM);
                        },
                        icon: Icon(Icons.save)),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
