import 'package:dvt/controls/text.dart';
import 'package:dvt/models/stocks.dart';
import 'package:flutter/material.dart';

class CurrentWeatherComponent extends StatelessWidget {
  const CurrentWeatherComponent({
    super.key,
    required this.currentAddress,
    required this.currentWeather,
    required this.currentWeatherImage,
  });
  final Image? currentWeatherImage;
  final dynamic currentWeather;
  final String? currentAddress;

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
                text: currentWeather['main']['temp'],
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
                    text: currentAddress,
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
