import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_haul/authController.dart';
import 'package:go_haul/cargoGenerator.dart';
import 'package:go_haul/utils/extension.dart';

class BookingList {
  static FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  static DateTime now = Get.find<CargoGenController>().dateTime as DateTime;
  static addBookingList() {
    DocumentReference<Map<String, dynamic>> _itemReference = _firebaseFirestore
        .collection("users")
        .doc(Get.find<Auth>().userData as String);
    var data1 = {
      'sAdd': Get.find<CargoGenController>().startAdd,
      "dAdd": Get.find<CargoGenController>().destAdd,
      "cargoType": Get.find<CargoGenController>().cargoType,
      "price": Get.find<CargoGenController>().price,
      "date": "${DateTime(now.year, now.month, now.day, now.hour, now.minute)}",
      "status": "Undelivered",
      "payment": "done"
    };
    var data = {
      ...data1,
      "history": FieldValue.arrayUnion([data1])
    };

    return _itemReference.set(data, SetOptions(merge: true));
  }
}
