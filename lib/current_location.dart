// ignore_for_file: prefer_const_constructors

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as a;
import 'package:geolocator/geolocator.dart' as b;
import 'package:go_haul/cargoGenerator.dart';
import 'dart:ui' as ui;
import 'package:go_haul/locationService.dart';
import 'package:go_haul/utils/extension.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:location/location.dart';

class UserLocation extends StatefulWidget {
  @override
  _UserLocationState createState() => _UserLocationState();
}

class _UserLocationState extends State<UserLocation> {
  String? _mapStyle;
  GoogleMapController? _controller;
  String? _currentAddress;
  Location currentLocation = Location();
  Set<Marker> markers = {};
  LatLng abc = LatLng(0.0, 0.0);
  b.Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/mapstyle.txt').then((string) {
      _mapStyle = string;
    });
    _getCurrentLocation();
    Get.find<CargoGenController>().cargoList.clear();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(CargoGenController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.green,
        title: text("Locations",
            textColor: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25.0),
      ),
      body: SizedBox(
        height: context.deviceHeight,
        width: context.deviceWidth,
        child: GoogleMap(
          zoomControlsEnabled: false,
          mapType: MapType.normal,
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
          initialCameraPosition: CameraPosition(
            target: LatLng(40.0, 40.0),
            zoom: 12.0,
          ),
          onMapCreated: (GoogleMapController controller) {
            _controller = controller;
            _controller?.setMapStyle(_mapStyle);
          },
          markers: markers,
        ),
      ),
    );
  }

  _getCurrentLocation() async {
    final Uint8List? markerIcon =
        await getBytesFromAsset("images/service.png", 150);
    await b.Geolocator.getCurrentPosition(
      desiredAccuracy: b.LocationAccuracy.best,
    ).then((b.Position position) async {
      setState(() {
        _currentPosition = position;
        print('CURRENT POS: $_currentPosition');
        _controller?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18.0,
            ),
          ),
        );
      });
      await _getAddress(
          _currentPosition!.latitude, _currentPosition!.longitude);
    }).catchError((e) {
      print(e);
    });

    Marker marke = Marker(
      markerId: MarkerId("oid"),
      infoWindow: InfoWindow(title: _currentAddress),
      position: LatLng(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      ),
    );
    setState(() {
      markers.add(marke);
      abc = LatLng(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );
    });
    Get.find<CargoGenController>().startUpdate(abc);
    Get.find<CargoGenController>().cargoListLocation();

    setState(() {
      markers.addAll(Get.find<CargoGenController>().cargoList.map((e) => Marker(
          icon: BitmapDescriptor.fromBytes(markerIcon!),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Confirm"),
                  content: Text(
                      "Are you sure to do booking for ${Get.find<CargoGenController>().cargoType} ${Get.find<CargoGenController>().cargoList.indexOf(e) + 1} ?"),
                  actions: <Widget>[
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              AppColors.green)),
                      child: Text("Yes"),
                      onPressed: () {
                        Get.find<CargoGenController>().destination = e;
                        Get.find<CargoGenController>().destAdd =
                            "${Get.find<CargoGenController>().cargoType} ${Get.find<CargoGenController>().cargoList.indexOf(e) + 1}";
                        Get.to(LocatingServiceProvider(pos: abc));
                      },
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(AppColors.red)),
                      child: Text("No"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
          markerId: MarkerId(e.latitude.toString()),
          infoWindow: InfoWindow(
              title:
                  "${Get.find<CargoGenController>().cargoType} ${Get.find<CargoGenController>().cargoList.indexOf(e) + 1} "),
          position: LatLng(e.latitude, e.longitude))));
    });
  }

  _getAddress(double lat, long) async {
    try {
      List<a.Placemark> p = await a.placemarkFromCoordinates(lat, long);

      a.Placemark place = p[0];
      setState(() {
        _currentAddress =
            "${place.street}, ${place.subLocality}, ${place.locality},${place.country}";
      });
      Get.find<CargoGenController>().startAdd = _currentAddress;
    } catch (e) {
      print(e);
    }
  }

  Future<Uint8List?> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        ?.buffer
        .asUint8List();
  }
}
