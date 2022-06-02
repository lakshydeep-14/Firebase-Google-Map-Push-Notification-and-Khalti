import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_haul/utils/extension.dart';

class Auth extends GetxController {
  final Future<SharedPreferences> _preferences =
      SharedPreferences.getInstance();
  FirebaseAuth? _auth;
  User? _user;
  String? userData;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController name = TextEditingController();

  Auth.initialize() : _auth = FirebaseAuth.instance {
    _auth?.authStateChanges().listen((event) {
      _onStateChanged(event!);
    });
  }

  Future<bool> signIn({required String email, password}) async {
    try {
      var details = FirebaseFirestore.instance
          .collection("users")
          .doc(Get.find<Auth>().userData as String);
      final SharedPreferences prefs = await _preferences;

      await _auth
          ?.signInWithEmailAndPassword(
              email: email.trim(), password: password.trim())
          .then((result) {
        prefs.setString("UID", result.user?.uid as String);
        userData = result.user?.uid as String;
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> signUp({required String email, password}) async {
    try {
      final SharedPreferences prefs = await _preferences;

      await _auth!
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((result) {
        _firestore.collection('users').doc(result.user?.uid).set({
          'name': email,
          'email': email,
          'uid': result.user?.uid,
          "verified": false,
          "pwd": password,
          "history": [],
          "token": ""
        });
        prefs.setString("UID", result.user?.uid as String);
        userData = result.user?.uid as String;
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _onStateChanged(User firebaseUser) async {
    _user = firebaseUser;
  }

  void clearController() {
    name.text = "";
  }

  Future signOut() async {
    _auth?.signOut();

    return Future.delayed(Duration.zero);
  }
}
