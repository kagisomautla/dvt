import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dvt/providers/locations.dart';
import 'package:dvt/providers/system.dart';
import 'package:dvt/screens/favorites/favorites.dart';
import 'package:dvt/screens/google_map/google_map.dart';
import 'package:dvt/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

Future main() async {
  await dotenv.load(fileName: "assets/.env");
  Connectivity().checkConnectivity();
  runApp(const WeatherApplication());
}

class WeatherApplication extends StatelessWidget {
  const WeatherApplication({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LocationsProvider>(create: (_) => LocationsProvider()),
        ChangeNotifierProvider<SystemProvider>(create: (_) => SystemProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        routes: <String, WidgetBuilder>{
          '/': (BuildContext context) => HomeScreen(),
          '/favorites': (BuildContext context) => FavoritesScreen(),
          '/google_map': (BuildContext context) => GoogleMapScreen(),
        },
      ),
    );
  }
}
