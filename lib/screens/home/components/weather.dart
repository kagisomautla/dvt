import 'package:dvt/controls/text.dart';
import 'package:flutter/material.dart';

class WeatherComponent extends StatelessWidget {
  const WeatherComponent({
    super.key,
    required this.address,
    required this.currentWeather,
    required this.currentWeatherImage,
  });
  final Image? currentWeatherImage;
  final dynamic currentWeather;
  final String? address;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2.5,
      child: Stack(
        alignment: AlignmentDirectional.center,
        fit: StackFit.expand,
        children: [
          currentWeatherImage!,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextControl(
                text: '${currentWeather['main']['temp']}°',
                isBold: true,
                size: TextProps.xl,
                color: Colors.white,
              ),
              SizedBox(
                height: 2,
              ),
              TextControl(
                text: currentWeather['weather'][0]['main'].toString().toUpperCase(),
                size: TextProps.lg,
                color: Colors.white,
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Icon(Icons.pin_drop),
                  SizedBox(
                    width: 5,
                  ),
                  TextControl(
                    text: address,
                    size: TextProps.normal,
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
