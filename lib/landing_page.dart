import 'dart:async';

import 'package:dvt/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  init() {
    int seconds = 1;
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          timer.cancel();
        }
      });
    });
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSunny,
      body: Center(
        child: Container(
          clipBehavior: Clip.antiAlias,
          height: 80,
          width: 80,
          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(100))),
          child: Image.asset(
            'assets/icons/app_icon.png',
            height: 100,
            width: 100,
          ),
        ),
      ),
    );
  }
}
