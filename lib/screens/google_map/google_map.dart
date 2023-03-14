import 'package:dvt/controls/text.dart';
import 'package:dvt/models/locations.dart';
import 'package:dvt/providers/locations.dart';
import 'package:dvt/providers/system.dart';
import 'package:dvt/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class GoogleMapScreen extends StatefulWidget {
  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  late GoogleMapController mapController;
  LatLng? _center;
  bool loading = true;
  Set<Marker> _favoritedLocationsMarkers = Set<Marker>();
  bool isGoTo = false;
  LocationsModel? location;
  int numberOfFaveLocations = 0;
  int indexOfLocation = 1;

  init() {
    print('init');
    LocationsProvider locationsProvider = Provider.of<LocationsProvider>(context, listen: false);
    numberOfFaveLocations = locationsProvider.favoriteLocations.length;
    setState(() {
      if (numberOfFaveLocations > 0) {
        for (var location in locationsProvider.favoriteLocations) {
          int index = locationsProvider.favoriteLocations.indexOf(location);
          _favoritedLocationsMarkers.add(
            Marker(
              markerId: MarkerId(index.toString()),
              position: location.location!,
              infoWindow: InfoWindow(title: location.address),
            ),
          );
        }
      } else {
        _favoritedLocationsMarkers.add(
          Marker(
            markerId: MarkerId(locationsProvider.selectedLocation!.address!),
            position: locationsProvider.selectedLocation!.location!,
            infoWindow: InfoWindow(title: locationsProvider.selectedLocation!.address),
          ),
        );
      }

      _center = locationsProvider.selectedLocation!.location;
      loading = false;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
  }

  handleGoToAndBack() {
    LocationsProvider locationsProvider = Provider.of<LocationsProvider>(context, listen: false);

    print(locationsProvider.favoriteLocations.length);

    if (isGoTo) {
      print(indexOfLocation);
      if (indexOfLocation > locationsProvider.favoriteLocations.length) {
        return;
      }
      setState(() {
        location = locationsProvider.favoriteLocations[indexOfLocation - 1];
      });
      ++indexOfLocation;
    } else {
      if (indexOfLocation == 1) {
        return;
      }
      --indexOfLocation;
      setState(() {
        location = locationsProvider.favoriteLocations[indexOfLocation - 1];
      });
    }

    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: location!.location!, zoom: 17),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LocationsProvider locationsProvider = Provider.of<LocationsProvider>(context);
    SystemProvider systemProvider = Provider.of<SystemProvider>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            FaIcon(
              FontAwesomeIcons.mapLocation,
              color: kSunny,
            ),
            SizedBox(
              width: 10,
            ),
            TextControl(
              text: 'Google Map',
              size: TextProps.normal,
              color: Colors.black,
            ),
          ],
        ),
      ),
      body: loading
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
                    text: 'Loading google map. Please wait...',
                    size: TextProps.normal,
                  ),
                ],
              ),
            )
          : Stack(
              alignment: AlignmentDirectional.center,
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _center!,
                    zoom: 12.0,
                  ),
                  myLocationButtonEnabled: true,
                  markers: _favoritedLocationsMarkers,
                  myLocationEnabled: true,
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: indexOfLocation == 1
                            ? null
                            : () {
                                setState(() {
                                  isGoTo = false;
                                });
                                handleGoToAndBack();
                              },
                        child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(10),
                          child: FaIcon(
                            FontAwesomeIcons.arrowLeft,
                            color: indexOfLocation == 1 ? Colors.grey : Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: indexOfLocation > locationsProvider.favoriteLocations.length
                            ? null
                            : () {
                                setState(() {
                                  isGoTo = true;
                                });
                                handleGoToAndBack();
                              },
                        child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(10),
                          child: FaIcon(
                            FontAwesomeIcons.arrowRight,
                            color: indexOfLocation > locationsProvider.favoriteLocations.length ? Colors.grey : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
