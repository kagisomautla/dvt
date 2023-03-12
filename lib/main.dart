import 'package:dvt/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: "assets/.env");

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
    
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => HomeScreen(),
      },
    );
  }
}

