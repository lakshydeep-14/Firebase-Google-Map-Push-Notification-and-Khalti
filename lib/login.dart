// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:go_haul/dashboard.dart';
import 'package:go_haul/utils/extension.dart';

import 'authController.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  var emailCont = TextEditingController();
  var passwordCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userAuth = Get.put(Auth.initialize());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: AppColors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                height: 150,
                width: 150,
                child: Image.asset(
                  "images/logo.png",
                  color: AppColors.black,
                )),
            SizedBox(
              height: 30,
            ),
            Container(
                width: 340.0,
                child: textInputContainer(
                  hint: "Email",
                  textEditingController: emailCont,
                  inputType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                )),
            SizedBox(
              height: 25,
            ),
            Container(
                width: 340.0,
                child: textInputContainer(
                  hint: "Password",
                  obscure: true,
                  suffix: true,
                  textEditingController: passwordCont,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                )),
            SizedBox(
              height: 25,
            ),
            ElevatedButton(
              child: text("SIGN IN", textColor: AppColors.white),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(AppColors.green)),
              onPressed: () async {
                final email = emailCont.text;
                final pass = passwordCont.text;
                if (_formKey.currentState!.validate()) {
                  final user =
                      await userAuth.signIn(email: email, password: pass);
                  if (user) {
                    Get.offAll(Dashboard());
                  } else {
                    Get.snackbar(
                        "Unable to sign in!", "Wrong email or password",
                        snackPosition: SnackPosition.BOTTOM);
                  }
                }
              },
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  height: 2,
                  width: 100,
                  color: AppColors.blue,
                ),
                text("Or Sign up ", textColor: AppColors.blue, fontSize: 12.5),
                Container(
                  height: 2,
                  width: 100,
                  color: AppColors.blue,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              child: text("SIGN UP", textColor: AppColors.white),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(AppColors.red)),
              onPressed: () async {
                final email = emailCont.text;
                final pass = passwordCont.text;
                if (_formKey.currentState!.validate()) {
                  final user =
                      await userAuth.signUp(email: email, password: pass);
                  if (user) {
                    Get.offAll(Dashboard());
                  } else {
                    Get.snackbar(
                        "Unable to sign in!", "Wrong email or password",
                        snackPosition: SnackPosition.BOTTOM);
                  }
                }
              },
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
