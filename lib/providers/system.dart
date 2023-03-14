import 'package:flutter/material.dart';

class SystemProvider with ChangeNotifier {
  bool? _isOnline;
  bool? get isOnline => _isOnline;
  set isOnline(bool? newVal) {
    _isOnline = newVal;
    notifyListeners();
  }

  Color? _backgroundColor;
  Color? get backgroundColor => _backgroundColor;
  set backgroundColor(Color? newVal) {
    _backgroundColor = newVal;
    notifyListeners();
  }
}
