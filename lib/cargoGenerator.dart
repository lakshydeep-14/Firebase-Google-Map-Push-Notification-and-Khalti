// ignore_for_file: prefer_const_constructors

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CargoGenController extends GetxController {
  int? price;
  DateTime? dateTime;
  String cargoType = "Bus";
  String? startAdd, destAdd;
  LatLng start = LatLng(0.0, 0.0);
  LatLng? destination;
  List<LatLng> cargoList = [];
  startUpdate(LatLng a) {
    start = a;
    update();
  }

  cargoListLocation() {
    cargoList.add(LatLng(start.latitude + 0.0002, start.longitude + 0.0006));
    cargoList.add(LatLng(start.latitude + 0.00001, start.longitude + 0.0006));
    cargoList.add(LatLng(start.latitude - 0.0002, start.longitude - 0.0006));
    cargoList.add(LatLng(start.latitude - 0.00001, start.longitude - 0.0006));
    cargoList.add(LatLng(start.latitude - 0.001, start.longitude + 0.0001));
    cargoList.add(LatLng(start.latitude + 0.001, start.longitude - 0.0001));
    cargoList.add(LatLng(start.latitude + 0.01, start.longitude - 0.01));

    update();
  }
}
