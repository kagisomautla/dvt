import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final FlutterSecureStorage storage = FlutterSecureStorage();

Future<dynamic> fetchFavoriteLocations() async {
  String? data = await storage.read(key: 'favorite_locations');
  return data;
}

Future<dynamic> fetchOfflineWeather() async {
  String? data = await storage.read(key: 'offline_weather');
  return data;
}
