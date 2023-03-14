import 'dart:io';

import 'package:dvt/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<dynamic> getWeather({required BuildContext context, required String type, required dynamic lat, required dynamic lon}) async {
  String apiPath = 'data/2.5/$type';
  final apiKey = dotenv.env['WEATHER_API_KEY'];
  final apiHost = dotenv.env['CURRENT_WEATHER_URL'];
  final apiQueryParams = {'lat': lat, 'lon': lon, 'appid': apiKey, "units": "metric"};

  final uri = Uri.https(apiHost!, apiPath, apiQueryParams);

  final response = await http.get(uri);

  return response;
}
