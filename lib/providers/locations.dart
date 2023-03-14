import 'package:dvt/models/locations.dart';
import 'package:flutter/material.dart';

class LocationsProvider with ChangeNotifier {
  LocationsModel? _selectedLocation;
  LocationsModel? get selectedLocation => _selectedLocation;
  set selectedLocation(LocationsModel? newVal) {
    _selectedLocation = newVal;
    notifyListeners();
  }

  List<LocationsModel> _favoriteLocations = [];
  List<LocationsModel> get favoriteLocations => _favoriteLocations;
  set favoriteLocations(List<LocationsModel> newVal) {
    _favoriteLocations = newVal;
    notifyListeners();
  }

  bool _isFavorite = false;
  bool get isFavorite => _isFavorite;
  set isFavorite(bool newVal) {
    _isFavorite = newVal;
    notifyListeners();
  }
}
