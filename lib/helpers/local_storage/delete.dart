import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final FlutterSecureStorage storage = FlutterSecureStorage();

deleteLocationInfomation() async {
  await storage.delete(key: 'favorite_locations');
}

deleteOfflineWeatherInformation() async {
  await storage.delete(key: 'offline_weather');
}

deleteAll() async {
  await storage.deleteAll();
}
