import 'package:dvt/controls/text.dart';
import 'package:dvt/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

void showSnackBar({required BuildContext context, required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: kSunny,
      content: TextControl(
        text: message,
        color: Colors.white,
      ),
    ),
  );
}

String convertDateTime({required String date, required bool convertToDaysOfTheWeek}) {
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

Future<dynamic> getCurrentPosition(BuildContext context) async {
  print("... getCurrentPosition");

  final hasPermission = await handleLocationPermission(context);
  dynamic position;

  if (!hasPermission) return null;
  await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((dynamic pos) async {
    position = pos;
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
    currentAddress = '${place.locality}, ${place.country}';
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
