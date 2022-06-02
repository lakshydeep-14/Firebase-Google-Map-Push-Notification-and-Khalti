// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'dart:ui' as ui;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:go_haul/cargoGenerator.dart';
import 'package:go_haul/checkout.dart';
import 'package:go_haul/khalti.dart';
import 'package:go_haul/utils/extension.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocatingServiceProvider extends StatefulWidget {
  final LatLng pos;

  const LocatingServiceProvider({Key? key, required this.pos})
      : super(key: key);

  @override
  _LocatingServiceProviderState createState() =>
      _LocatingServiceProviderState();
}

class _LocatingServiceProviderState extends State<LocatingServiceProvider> {
  String? _mapStyle;
  GoogleMapController? _controller;
  String? _currentAddress;
  PolylinePoints? polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  Set<Marker> markers = {};
  double lat = 0.0, long = 0.0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool loading = false;

  addAllListData() async {
    _createPolylines(Get.find<CargoGenController>().start,
        Get.find<CargoGenController>().destination as LatLng);
  }

  @override
  void initState() {
    super.initState();
    addAllListData();
    rootBundle.loadString('assets/mapstyle.txt').then((string) {
      _mapStyle = string;
    });
  }

  @override
  Widget build(BuildContext context) {
    Get.put(CargoGenController());
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: AppColors.green,
          title: text("Routes",
              textColor: AppColors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25.0),
        ),
        backgroundColor: AppColors.background,
        floatingActionButton: FloatingActionButton.extended(
            backgroundColor: AppColors.green,
            onPressed: () {
              Get.to(Checkout());
            },
            label: text("BOOK", textColor: AppColors.white)),
        body: Stack(children: [
          GoogleMap(
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            compassEnabled: true,
            initialCameraPosition: CameraPosition(
                target: LatLng(widget.pos.latitude, widget.pos.longitude),
                zoom: 15.0),
            polylines: Set<Polyline>.of(polylines.values),
            markers: Set<Marker>.from(markers),
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
              _controller?.setMapStyle(_mapStyle);
            },
          ),
        ]));
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

  _createPolylines(LatLng start, LatLng destination) async {
    final Uint8List? markerIcon =
        await getBytesFromAsset("images/service.png", 150);
    final Uint8List? destinationIcon =
        await getBytesFromAsset("images/service.png", 150);

    polylinePoints = PolylinePoints();
    Marker marke = Marker(
      markerId: MarkerId("oid"),
      infoWindow: InfoWindow(title: Get.find<CargoGenController>().startAdd),
      position: LatLng(
        start.latitude,
        start.longitude,
      ),
    );
    setState(() {
      markers.add(marke);
    });
    Marker destinationMarker = Marker(
        markerId: MarkerId("did"),
        infoWindow: InfoWindow(title: Get.find<CargoGenController>().destAdd),
        position: LatLng(
          destination.latitude,
          destination.longitude,
        ),
        icon: BitmapDescriptor.fromBytes(destinationIcon!));
    setState(() {
      markers.add(destinationMarker);
    });
    // PolylineResult? result = await polylinePoints?.getRouteBetweenCoordinates(
    //   "AIzaSyCIQtTwxlWMNWfvibHTY7PhDijnvEHG798",
    //   PointLatLng(start.latitude, start.longitude),
    //   PointLatLng(destination.latitude, destination.longitude),
    //   travelMode: TravelMode.transit,
    // );
    // print("11111111111111111111111");
    // print(result!.status);

    // if (result.points.isNotEmpty) {
    //   result.points.forEach((PointLatLng point) {
    //     polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    //   });
    // }

    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: AppColors.black,
      points: [
        LatLng(start.latitude, start.longitude),
        LatLng(destination.latitude, destination.longitude),
      ],
      width: 3,
    );
    polylines[id] = polyline;
  }
}
