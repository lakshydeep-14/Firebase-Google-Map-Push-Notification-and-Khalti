import 'package:flutter/material.dart';
import 'package:flutter_khalti/flutter_khalti.dart';
import 'package:get/get.dart';
import 'package:go_haul/book.dart';
import 'package:go_haul/cargoGenerator.dart';
import 'package:go_haul/dashboard.dart';

khaltiScreen(BuildContext context) {
  FlutterKhalti _flutterKhalti = FlutterKhalti.configure(
      publicKey: "", //Add your public key
      urlSchemeIOS: "KhaltiPayFlutterExampleSchema");
  KhaltiProduct product = KhaltiProduct(
    id: "test",
    amount: 1000,
    name: "Payment for item",
  );
  _flutterKhalti.startPayment(
      product: product,
      onSuccess: (data) async {
        try {
          await BookingList.addBookingList().then((value) => Get.snackbar(
              "Successful", "Booked Successfully",
              duration: Duration(seconds: 2),
              snackPosition: SnackPosition.BOTTOM));
          Get.find<CargoGenController>().cargoList.clear();
          Get.offAll(Dashboard());
        } catch (e) {
          print(e);
        }
        print("success");
      },
      onFaliure: (error) {
        print(error);
      });
}
