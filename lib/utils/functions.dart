import 'dart:convert';
import 'dart:io';

import 'package:dvt/controls/text.dart';
import 'package:dvt/models/locations.dart';
import 'package:dvt/providers/system.dart';
import 'package:dvt/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

void showSnackBar({required BuildContext context, required String message, Color? textColor}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      elevation: 2,
      duration: Duration(seconds: 2),
      shape: Border(top: BorderSide(color: Colors.white)),
      content: TextControl(
        text: message,
        color: textColor ?? Colors.white,
        isBold: true,
      ),
    ),
  );
}

String convertDateTime({
  required String date,
  required bool convertToDaysOfTheWeek,
}) {
  DateTime dt = DateTime.parse(date);
  String formattedDate = '';

  if (convertToDaysOfTheWeek) {
    formattedDate = DateFormat.EEEE().format(dt);
  } else {
    formattedDate = DateFormat.yMd().format(dt);
  }

  return formattedDate;
}

Future<dynamic> handleLocationPermission(BuildContext context) async {
  print("... handleLocationPermission");
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    showSnackBar(context: context, message: 'Location services are disabled');
    return false;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      showSnackBar(context: context, message: 'Location permissions are denied');
      return false;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    showSnackBar(context: context, message: 'Location permissions are permanently denied, we cannot request permissions');
    return false;
  }

  return true;
}

Future<LatLng?> getCurrentPosition(BuildContext context) async {
  // print("... getCurrentPosition");

  final hasPermission = await handleLocationPermission(context);
  LatLng? position;

  if (!hasPermission) return null;
  await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position pos) async {
    position = LatLng(pos.latitude, pos.longitude);
  }).catchError((e) {
    debugPrint(e);
  });

  return position;
}

Future<String?> getAddressFromLatLng(lat, lon) async {
  print("... getAddressFromLatLng");

  String? currentAddress;
  await placemarkFromCoordinates(lat, lon).then((List<Placemark> placemarks) {
    Placemark place = placemarks[0];
    currentAddress = '${place.subLocality}, ${place.locality}, ${place.country}';
  }).catchError((e) {
    debugPrint(e);
    return e;
  });

  return currentAddress ?? '';
}

List<dynamic> extractDaysOfTheWeekData(List<dynamic> list) {
  List<dynamic> extractedList = [];
  int counter = 0;

  do {
    counter++;

    if (counter < list.length - 1) {
      if (convertDateTime(date: list[counter]['dt_txt'], convertToDaysOfTheWeek: false) != convertDateTime(date: list[counter + 1]['dt_txt'], convertToDaysOfTheWeek: false)) {
        extractedList.add(list[counter + 1]);
      }
    }
  } while (counter <= list.length);

  return extractedList;
}
