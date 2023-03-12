import 'dart:convert' as convert;
import 'package:dvt/apis/get_weather.dart';
import 'package:dvt/controls/text.dart';
import 'package:dvt/models/stocks.dart';
import 'package:dvt/screens/home/components/current_weather.dart';
import 'package:dvt/screens/home/components/forecast.dart';
import 'package:dvt/utils/constants.dart';
import 'package:dvt/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? currentAddress;
  bool loadingHomePage = true;
  dynamic currentWeather;
  List<dynamic>? forecast;
  Image? currentWeatherImage;
  Color? backgroundColor;
  bool isSearching = false;
  bool showMap = false;
  GoogleMapController? mapController; //contrller for Google map
  CameraPosition? cameraPosition;
  LatLng startLocation = LatLng(-26.195246, 28.034088);
  String location = "Search Location";
  bool showWeatherBySearch = false;
  LatLng? searchLatLng;
  dynamic position;
  bool loadingData = false;

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    if (showWeatherBySearch) {
      //show weather by current location
      setState(() {
        position = searchLatLng;
      });
    } else {
      //show weather by current location
      position = await getCurrentPosition(context);
    }

    print('position after operations: ${position.latitude}');

    if (position != null) {
      currentAddress = await getAddressFromLatLng(position.latitude, position.longitude);
      await getWeather(
        context: context,
        type: 'weather',
        lat: position.latitude.toString(),
        lon: position.longitude.toString(),
      ).then((response) async {
        if (response.statusCode == 200) {
          currentWeather = convert.jsonDecode(response.body) as Map<String, dynamic>;
        } else {
          showSnackBar(context: context, message: 'Failed to load weather... ${response.statusCode}.');
        }
      });
      await getWeather(
        context: context,
        type: 'forecast',
        lat: position.latitude.toString(),
        lon: position.longitude.toString(),
      ).then((response) async {
        if (response.statusCode == 200) {
          dynamic body = convert.jsonDecode(response.body) as Map<String, dynamic>;
          List<dynamic> listOfForecast = body['list'];
          forecast = extractDaysOfTheWeekData(listOfForecast);
        } else {
          showSnackBar(context: context, message: 'Failed to load forecast... ${response.statusCode}.');
        }
      });
    }

    setState(() {
      loadingHomePage = false;
      loadingData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentWeather != null) {
      switch (currentWeather['weather'][0]['main'].toString().toLowerCase()) {
        case 'clear':
          setState(() {
            currentWeatherImage = Image.asset('assets/images/forest_sunny.png', fit: BoxFit.fill);
            backgroundColor = kSunny;
          });
          break;
        case 'clouds':
          setState(() {
            currentWeatherImage = Image.asset('assets/images/forest_cloudy.png', fit: BoxFit.fill);
            backgroundColor = kCloudy;
          });
          break;
        case 'rainy':
        case 'thuderstorm':
        case 'drizzle':
          setState(() {
            currentWeatherImage = Image.asset('assets/images/forest_rainy.png', fit: BoxFit.fill);
            backgroundColor = kRainy;
          });
          break;
        default:
          setState(() {
            currentWeatherImage = Image.asset('assets/images/forest_sunny.png', fit: BoxFit.fill);
            backgroundColor = kSunny;
          });
      }
    }
    return loadingHomePage == true
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/loader.gif',
                    height: MediaQuery.of(context).size.height / 6,
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: backgroundColor,
              actions: [
                showWeatherBySearch
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            showWeatherBySearch = false;
                            loadingData = true;
                            location = "Search Location";
                          });
                          init();
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.refresh,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            TextControl(
                              text: 'Use my location',
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      )
                    : Container()
              ],
            ),
            body: Stack(
              children: [
                loadingData
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextControl(
                              text: 'Loading weather based on your ${showWeatherBySearch ? 'search' : 'current'} location...',
                              size: TextProps.normal,
                              isBold: true,
                            ),
                            SpinKitCircle(
                              color: backgroundColor,
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            CurrentWeatherComponent(
                              currentAddress: currentAddress,
                              currentWeather: currentWeather,
                              currentWeatherImage: currentWeatherImage,
                            ),
                            showMap
                                ? Container(
                                    color: backgroundColor,
                                    height: MediaQuery.of(context).size.height / 2,
                                    child: GoogleMap(
                                      //Map widget from google_maps_flutter package
                                      zoomGesturesEnabled: true, //enable Zoom in, out on map
                                      initialCameraPosition: CameraPosition(
                                        //innital position in map
                                        target: startLocation, //initial position
                                        zoom: 14.0, //initial zoom level
                                      ),
                                      mapType: MapType.normal, //map type
                                      onMapCreated: (controller) {
                                        //method called when map is created
                                        setState(() {
                                          mapController = controller;
                                        });
                                      },
                                    ),
                                  )
                                : ForecastComponent(
                                    backgroundColor: backgroundColor,
                                    currentWeather: currentWeather,
                                    forecast: forecast,
                                  )
                          ],
                        ),
                      ),
                Positioned(
                  //search input bar
                  child: InkWell(
                    onTap: () async {
                      var place = await PlacesAutocomplete.show(
                          context: context,
                          apiKey: dotenv.env['GOOGLE_MAPS_API_KEY'],
                          mode: Mode.overlay,
                          types: [],
                          strictbounds: false,
                          location: Location(
                            lat: -26.195246,
                            lng: 28.034088,
                          )
                          // components: [
                          //   Component(Component.country, 'zim'),
                          // ],
                          );

                      if (place != null) {
                        setState(() {
                          location = place.description.toString();
                        });

                        //form google_maps_webservice package
                        final plist = GoogleMapsPlaces(
                          apiKey: dotenv.env['GOOGLE_MAPS_API_KEY'],
                          apiHeaders: await GoogleApiHeaders().getHeaders(),
                        );
                        String placeid = place.placeId ?? "0";
                        final detail = await plist.getDetailsByPlaceId(placeid);
                        final geometry = detail.result.geometry!;
                        final lat = geometry.location.lat;
                        final lang = geometry.location.lng;
                        var newlatlang = LatLng(lat, lang);
                        mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newlatlang, zoom: 17)));
                        setState(() {
                          loadingData = true;
                          showWeatherBySearch = true;
                          searchLatLng = LatLng(geometry.location.lat, geometry.location.lng);
                        });
                        init();
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Card(
                        child: Container(
                            padding: EdgeInsets.all(0),
                            width: MediaQuery.of(context).size.width - 40,
                            child: ListTile(
                              title: Text(
                                location,
                                style: TextStyle(fontSize: 18),
                              ),
                              trailing: Icon(Icons.search),
                              dense: true,
                            )),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
  }
}
