import 'dart:html';

import "package:flutter/material.dart";
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';


class MapScreen extends StatelessWidget {
  const MapScreen({Key? key}) : super(key: key);




  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: Scaffold(
        body: FireMap(),

      )
    );
  }
}




class FireMap extends StatefulWidget {
  State createState() => FireMapState();
}

class FireMapState extends State<FireMap> {

  build(context) {
    return Stack(children: [

      GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(48.99, 17.39),
          zoom: 15
        ),


          ),



    ],);
  }
}