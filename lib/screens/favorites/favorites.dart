import 'package:dvt/controls/pop_up.dart';
import 'package:dvt/controls/text.dart';
import 'package:dvt/helpers/local_storage/fetch.dart';
import 'package:dvt/helpers/local_storage/send.dart';
import 'package:dvt/models/locations.dart';
import 'package:dvt/providers/locations.dart';
import 'package:dvt/providers/system.dart';
import 'package:dvt/utils/constants.dart';
import 'package:dvt/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:focus_detector/focus_detector.dart';
import 'dart:convert';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  bool loading = true;
  init() async {
    LocationsProvider locationsProvider = Provider.of<LocationsProvider>(context, listen: false);
    dynamic favoriteLocationsFromStorage = await fetchFavoriteLocations();
    print('favoriteLocationsFromStorage: $favoriteLocationsFromStorage');

    if (favoriteLocationsFromStorage.isNotEmpty) {
      setState(() {
        List<dynamic> decodedData = json.decode(favoriteLocationsFromStorage);
        locationsProvider.favoriteLocations = decodedData
            .map((e) => LocationsModel(
                  location: LatLng(e['location'][0], e['location'][1]),
                  address: e['address'],
                ))
            .toList();
        print('decoded locations: $decodedData');
      });
      print('favorite locations: ${locationsProvider.favoriteLocations}');
    }

    setState(() {
      loading = false;
    });

    print('favorite locations: ${locationsProvider.favoriteLocations}');
  }

  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
  }

  handleClearAll() {
    LocationsProvider locationsProvider = Provider.of<LocationsProvider>(context, listen: false);
    popupControl(
      context: context,
      message: 'Are you sure you want to clear all your favorite locations?',
      title: 'Clear All',
      onConfirm: () {
        locationsProvider.favoriteLocations = [];
        storeFavoriteLocations(value: []);
        print(locationsProvider.favoriteLocations);
        print('Yes clicked');
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    LocationsProvider locationsProvider = Provider.of<LocationsProvider>(context);
    SystemProvider systemProvider = Provider.of<SystemProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Center(
            child: FaIcon(
              FontAwesomeIcons.arrowLeft,
              color: Colors.black,
            ),
          ),
        ),
        title: TextControl(
          text: 'Favorites',
          size: TextProps.normal,
          color: Colors.black,
          isBold: true,
        ),
        actions: [
          GestureDetector(
            onTap: () => handleClearAll(),
            child: Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Center(
                child: TextControl(
                  text: 'clear all',
                  color: Colors.black,
                ),
              ),
            ),
          )
        ],
      ),
      body: loading
          ? FocusDetector(
              onVisibilityGained: () {
                init();
              },
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitCircle(
                      color: kSunny,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextControl(
                      text: 'Loading your favorite locations...',
                      size: TextProps.normal,
                    ),
                  ],
                ),
              ),
            )
          : Container(
              padding: EdgeInsets.only(top: 10),
              child: locationsProvider.favoriteLocations.isEmpty
                  ? Center(
                      child: TextControl(
                        text: 'No favorite locations found.',
                        color: Colors.grey,
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: locationsProvider.favoriteLocations.map((location) {
                                print('location: ${location.address}');
                                int index = locationsProvider.favoriteLocations.indexOf(location);
                                return Dismissible(
                                  background: Container(color: Colors.red),
                                  key: Key(location.address!),
                                  onDismissed: (direction) {
                                    int idx = locationsProvider.favoriteLocations.indexWhere((e) => e.address == locationsProvider.selectedLocation!.address);

                                    if (idx > -1) {
                                      setState(() {
                                        locationsProvider.isFavorite = false;
                                      });
                                    }
                                    setState(() {
                                      locationsProvider.favoriteLocations.removeAt(index);
                                    });

                                    print('listOfFavoriteLocations after dismissal: ${locationsProvider.favoriteLocations}');
                                    storeFavoriteLocations(value: [...locationsProvider.favoriteLocations]);
                                    showSnackBar(context: context, message: '${location.address} removed from favorites.');
                                  },
                                  child: Card(
                                    child: ListTile(
                                      leading: FaIcon(
                                        FontAwesomeIcons.mapLocation,
                                        color: kSunny,
                                      ),
                                      trailing: FaIcon(
                                        FontAwesomeIcons.solidHeart,
                                        color: Colors.red,
                                      ),
                                      title: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TextControl(
                                            text: location.address,
                                            size: TextProps.md,
                                          ),
                                          Row(
                                            children: [
                                              TextControl(
                                                text: 'lat:',
                                                size: TextProps.normal,
                                                color: Colors.grey,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              TextControl(
                                                text: location.location!.latitude,
                                                size: TextProps.normal,
                                                color: kSunny,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              TextControl(
                                                text: 'lng:',
                                                size: TextProps.normal,
                                                color: Colors.grey,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              TextControl(
                                                text: location.location!.longitude,
                                                size: TextProps.normal,
                                                color: kSunny,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList()),
                          SizedBox(
                            height: 20,
                          ),
                          TextControl(
                            text: 'Swipe to unfavorite.',
                            color: Colors.grey,
                          )
                        ],
                      ),
                    ),
            ),
    );
  }
}
