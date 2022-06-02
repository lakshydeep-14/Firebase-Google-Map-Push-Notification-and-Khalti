import 'package:flutter/material.dart';
import 'package:go_haul/cargoGenerator.dart';
import 'package:go_haul/utils/extension.dart';

import 'khalti.dart';

class Checkout extends StatefulWidget {
  const Checkout({Key? key}) : super(key: key);

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  DateTime now = Get.find<CargoGenController>().dateTime as DateTime;
  @override
  Widget build(BuildContext context) {
    Get.put(CargoGenController());
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.green,
          title: text("Checkout",
              textColor: AppColors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25.0),
        ),
        body: Container(
            height: 500,
            padding: const EdgeInsets.all(15),
            decoration: boxDecoration(bordercolor: AppColors.green, radius: 15),
            margin: const EdgeInsets.all(15),
            child: _dataI()));
  }

  Widget _dataI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          children: [
            text("From: ", fontWeight: FontWeight.bold),
            text(Get.find<CargoGenController>().startAdd as String,
                fontWeight: FontWeight.normal),
          ],
        ),
        Row(
          children: [
            text("To: ", fontWeight: FontWeight.bold),
            text(Get.find<CargoGenController>().destAdd as String,
                fontWeight: FontWeight.normal),
          ],
        ),
        Row(
          children: [
            text("Via: ", fontWeight: FontWeight.bold),
            text(Get.find<CargoGenController>().cargoType,
                fontWeight: FontWeight.normal),
          ],
        ),
        Row(
          children: [
            text("Date: ", fontWeight: FontWeight.bold),
            text(
                "${DateTime(now.year, now.month, now.day, now.hour, now.minute)}",
                fontWeight: FontWeight.normal),
          ],
        ),
        Row(
          children: [
            text("Amount: ", fontWeight: FontWeight.bold),
            text("Rs. " + Get.find<CargoGenController>().price.toString(),
                fontWeight: FontWeight.normal),
          ],
        ),
        // Row(
        //   children: [
        //     text("From: ", fontWeight: FontWeight.bold),
        //     text(d['sAdd'], fontWeight: FontWeight.normal),
        //   ],
        // ),
        Row(
          children: [
            text("Status: ", fontWeight: FontWeight.bold),
            text(
              "Undelivered",
              fontWeight: FontWeight.w500,
              textColor: AppColors.red,
            ),
          ],
        ),
        Row(
          children: [
            text("payment: ", fontWeight: FontWeight.bold),
            text("undone",
                fontWeight: FontWeight.w500, textColor: AppColors.green),
          ],
        ),
        OutlinedButton(
            onPressed: () {
              khaltiScreen(context);
            },
            child: Text("CHECKOUT"))
      ],
    );
  }
}
