import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_haul/utils/extension.dart';

import 'authController.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  var details = FirebaseFirestore.instance
      .collection("users")
      .doc(Get.find<Auth>().userData as String)
      .get();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.green,
          title: text("History",
              textColor: AppColors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25.0),
        ),
        body: FutureBuilder<DocumentSnapshot>(
          future: details,
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              final _data = snapshot.data!['history'];
              if (_data.isEmpty) {
                return Center(
                  child: Text("No History"),
                );
              } else {
                return ListView.builder(
                    itemCount: _data.length,
                    itemBuilder: (context, i) {
                      final _d = _data[i];
                      return Container(
                          padding: const EdgeInsets.all(15),
                          decoration: boxDecoration(
                              bordercolor: AppColors.green, radius: 15),
                          margin: const EdgeInsets.all(15),
                          child: _dataI(_d));
                    });
              }
            }
          },
        ));
  }

  Widget _dataI(dynamic d) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            text("From: ", fontWeight: FontWeight.bold),
            text(d['sAdd'], fontWeight: FontWeight.normal),
          ],
        ),
        Row(
          children: [
            text("To: ", fontWeight: FontWeight.bold),
            text(d['dAdd'], fontWeight: FontWeight.normal),
          ],
        ),
        Row(
          children: [
            text("Via: ", fontWeight: FontWeight.bold),
            text(d['cargoType'], fontWeight: FontWeight.normal),
          ],
        ),
        Row(
          children: [
            text("Date: ", fontWeight: FontWeight.bold),
            text(d['date'], fontWeight: FontWeight.normal),
          ],
        ),
        Row(
          children: [
            text("Amount: ", fontWeight: FontWeight.bold),
            text("Rs. " + d['price'].toString(), fontWeight: FontWeight.normal),
          ],
        ),
        Row(
          children: [
            text("From: ", fontWeight: FontWeight.bold),
            text(d['sAdd'], fontWeight: FontWeight.normal),
          ],
        ),
        Row(
          children: [
            text("Status: ", fontWeight: FontWeight.bold),
            text(
              d['status'],
              fontWeight: FontWeight.w500,
              textColor: AppColors.red,
            ),
          ],
        ),
        Row(
          children: [
            text("payment: ", fontWeight: FontWeight.bold),
            text(d['payment'],
                fontWeight: FontWeight.w500, textColor: AppColors.green),
          ],
        ),
      ],
    );
  }
}
