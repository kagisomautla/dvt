import 'package:dvt/apis/get_weather.dart';
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
  bool loadingScreen = true;
  bool showWeather = false;
  bool loadingWeather = false;
  dynamic currentWeather;
  LocationsModel? selectedLocationData;
  Image? weatherImage;
  Color? backgroundColor;
  Icon? weatherIcon;

  init() async {
    LocationsProvider locationsProvider = Provider.of<LocationsProvider>(context, listen: false);
    dynamic favoriteLocationsFromStorage = await fetchFavoriteLocations();

    if (favoriteLocationsFromStorage.isNotEmpty) {
      setState(() {
        List<dynamic> decodedData = json.decode(favoriteLocationsFromStorage);
        locationsProvider.favoriteLocations = decodedData
            .map((e) => LocationsModel(
                  location: LatLng(e['location'][0], e['location'][1]),
                  address: e['address'],
                ))
            .toList();
      });
    }

    setState(() {
      loadingScreen = false;
    });

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
        Navigator.pop(context);
      },
    );
    setState(() {
      showWeather = false;
      backgroundColor = null;
    });
  }

  getWeatherForLocation(LocationsModel position) async {
    setState(() {
      showWeather = false;
      loadingWeather = true;
    });
    await getWeather(
      context: context,
      type: 'weather',
      lat: position.location!.latitude.toString(),
      lon: position.location!.longitude.toString(),
    ).then((response) {
      currentWeather = json.decode(response.body) as Map<String, dynamic>;
      setState(() {
        selectedLocationData = LocationsModel(location: position.location, address: position.address, weather: currentWeather);
        showWeather = true;
      });
    });

    setState(() {
      loadingWeather = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    LocationsProvider locationsProvider = Provider.of<LocationsProvider>(context);
    SystemProvider systemProvider = Provider.of<SystemProvider>(context);

    if (selectedLocationData != null) {
      switch (selectedLocationData!.weather!['weather'][0]['main'].toString().toLowerCase()) {
        case 'clear':
          setState(() {
            weatherImage = Image.asset('assets/images/forest_sunny.png', fit: BoxFit.fill);
            backgroundColor = kSunny;
            weatherIcon = Icon(
              FontAwesomeIcons.cloudSun,
              color: kSunny,
              size: 50,
            );
          });
          break;
        case 'clouds':
          setState(() {
            weatherImage = Image.asset('assets/images/forest_cloudy.png', fit: BoxFit.fill);
            backgroundColor = kCloudy;
            weatherIcon = Icon(
              FontAwesomeIcons.cloud,
              color: kCloudy,
              size: 50,
            );
          });
          break;
        case 'rain':
        case 'thuderstorm':
        case 'drizzle':
        case 'snow':
          setState(() {
            weatherImage = Image.asset(
              'assets/images/forest_rainy.png',
              fit: BoxFit.fill,
            );
            backgroundColor = kRainy;
            weatherIcon = Icon(
              FontAwesomeIcons.cloudRain,
              color: kRainy,
              size: 50,
            );
          });
          break;
        default:
          setState(() {
            weatherImage = Image.asset('assets/images/forest_sunny.png', fit: BoxFit.fill);
            backgroundColor = kSunny;
            weatherIcon = Icon(
              FontAwesomeIcons.cloudSun,
              color: kRainy,
              size: 50,
            );
          });
      }
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor ?? Colors.white,
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
      body: loadingScreen
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
                        color: backgroundColor != null ? Colors.white : Colors.grey,
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          loadingWeather
                              ? Center(
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
                                )
                              : showWeather
                                  ? ShowWeatherComponent(
                                      selectedLocationData: selectedLocationData,
                                      backgroundColor: backgroundColor!,
                                      image: weatherImage!,
                                      icon: weatherIcon!,
                                    )
                                  : Container(),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: locationsProvider.favoriteLocations.map((location) {
                                int index = locationsProvider.favoriteLocations.indexOf(location);
                                return GestureDetector(
                                  onTap: () {
                                    // popupControl(
                                    //   context: context,
                                    //   message: 'Would you like to see the weather for this location?',
                                    //   title: 'Load Weather for Location',
                                    //   onConfirm: () {

                                    //   },
                                    // );
                                    getWeatherForLocation(location);
                                  },
                                  child: Dismissible(
                                    background: Container(color: Colors.grey),
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
                                        showWeather = false;
                                        backgroundColor = Colors.white;
                                      });
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
                                  ),
                                );
                              }).toList()),
                          SizedBox(
                            height: 20,
                          ),
                          TextControl(
                            text: 'Swipe to unfavorite.',
                            color: backgroundColor != null ? Colors.white : Colors.grey,
                          )
                        ],
                      ),
                    ),
            ),
    );
  }
}

class ShowWeatherComponent extends StatelessWidget {
  const ShowWeatherComponent({
    super.key,
    required this.selectedLocationData,
    required this.backgroundColor,
    required this.image,
    required this.icon,
  });

  final LocationsModel? selectedLocationData;
  final Color backgroundColor;
  final Image image;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      width: double.infinity,
      color: backgroundColor,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          image,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              SizedBox(
                height: 40,
              ),
              TextControl(
                text: "${selectedLocationData?.weather?['main']['temp']}°",
                color: Colors.white,
                size: TextProps.lg,
                isBold: true,
              ),
              SizedBox(
                height: 20,
              ),
              FaIcon(
                FontAwesomeIcons.mapPin,
                color: Colors.white,
              ),
              TextControl(
                text: '${selectedLocationData?.address}',
                color: Colors.white,
                size: TextProps.normal,
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
