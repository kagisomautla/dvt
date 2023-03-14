import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationsModel {
  final LatLng? location;
  final String? address;
  final String? timeOfLastUpdate;
  final Map<String, dynamic>? weather;

  LocationsModel({this.location, this.address, this.timeOfLastUpdate, this.weather});

  Map<String, dynamic> toJson() {
    return {"location": location, "address": address, "time_of_last_update": timeOfLastUpdate, "weather": weather};
  }
}
