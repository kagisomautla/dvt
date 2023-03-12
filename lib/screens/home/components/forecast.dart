import 'package:dvt/controls/text.dart';
import 'package:dvt/utils/functions.dart';
import 'package:flutter/material.dart';

class ForecastComponent extends StatelessWidget {
  const ForecastComponent({
    super.key,
    required this.backgroundColor,
    required this.currentWeather,
    required this.forecast,
  });

  final Color? backgroundColor;
  final dynamic currentWeather;
  final List? forecast;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      height: MediaQuery.of(context).size.height / 2,
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      TextControl(
                        text: currentWeather['main']['temp_min'],
                        color: Colors.white,
                        isBold: true,
                      ),
                      TextControl(
                        text: 'min',
                        color: Colors.white,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      TextControl(
                        text: currentWeather['main']['temp'],
                        color: Colors.white,
                        isBold: true,
                      ),
                      TextControl(
                        text: 'current',
                        color: Colors.white,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      TextControl(
                        text: currentWeather['main']['temp_max'],
                        color: Colors.white,
                        isBold: true,
                      ),
                      TextControl(
                        text: 'max',
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
              Divider(
                thickness: 1,
                color: Colors.white,
              ),
            ],
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: forecast!.map((weather) {
                String day = convertDateTime(date: weather['dt_txt'], convertToDaysOfTheWeek: true);
                return DayOfTheWeek(
                  icon: weather['weather'][0]['icon'],
                  day: day,
                  temperature: weather['main']['temp'],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class DayOfTheWeek extends StatefulWidget {
  const DayOfTheWeek({
    super.key,
    required this.day,
    required this.temperature,
    required this.icon,
  });

  final String day;
  final String icon;
  final dynamic temperature;

  @override
  State<DayOfTheWeek> createState() => _DayOfTheWeekState();
}

class _DayOfTheWeekState extends State<DayOfTheWeek> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextControl(
            text: widget.day,
            color: Colors.white,
          ),
        ),
        Image.network(
          'https://openweathermap.org/img/wn/${widget.icon}@2x.png',
          height: 50,
          width: 50,
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: TextControl(
              text: '${widget.temperature}°',
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
