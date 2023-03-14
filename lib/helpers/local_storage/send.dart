import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../models/locations.dart';

final FlutterSecureStorage storage = FlutterSecureStorage();

storeFavoriteLocations({required List<LocationsModel> value}) async {
  await storage.write(key: 'favorite_locations', value: jsonEncode(value));
}

storeOfflineWeather({required LocationsModel value}) async {
  await storage.write(key: 'offline_weather', value: jsonEncode(value));
}
