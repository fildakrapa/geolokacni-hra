//import 'dart:html';

import "package:flutter/material.dart";
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';




class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
late GoogleMapController googleMapController;
static const CameraPosition initialCameraPosition = CameraPosition(target: LatLng(98, 110));

  LocationData? currentLocation;

  void getCurrentLocation() {
    Location location = Location();

    location.getLocation().then(
        (location) {
          currentLocation = location;
        },
    );
  }

  @override
  void initState() {
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  GoogleMap(
      initialCameraPosition: initialCameraPosition,
      zoomControlsEnabled: false,
      mapType: MapType.normal,
      onMapCreated: (GoogleMapController controler){
        googleMapController = controler;
      }
      ),


  //        markers: {
   //   Marker(
  //    markerId: const MarkerId("currentLocation"),
  //    position: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
  //    )
  //    }

  //    ),
     


      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Position position = await _determinePosition();
          
          googleMapController
          .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude, position.longitude),zoom: 13.5 )));

        },
        label: const Text('Já'),
        icon: const Icon(Icons.location_history),
      ),


    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Poloha není povolena");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Poloha není povolena");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error("Poloha je zakázána");
    }

    Position position = await Geolocator.getCurrentPosition();
    return position;
  }
  }