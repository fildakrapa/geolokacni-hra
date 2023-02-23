import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class MapSample extends StatefulWidget {
  @override
  _MapSampleState createState() => _MapSampleState();
}

class _MapSampleState extends State<MapSample> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _getMarkers();
  }

  void _getMarkers() async {
    QuerySnapshot querySnapshot =
    await _db.collection('pamatky').get(); // získání dat z Firestore

    setState(() {
      _markers = querySnapshot.docs.map((doc) {
        GeoPoint position = doc['location']; // získání souřadnic z Firestore
        String name = doc['name']; // získání názvu z Firestore
        return Marker(
          markerId: MarkerId(doc.id),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: InfoWindow(title: name),
        );
      }).toSet();
    });

  }

  Future<void> _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    Marker userMarker = Marker(
      markerId: MarkerId('user'),
      position: LatLng(position.latitude, position.longitude),
      infoWindow: InfoWindow(title: 'Moje poloha'),
    );
    setState(() {
      _markers = {..._markers, userMarker};
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Mapa'),
        actions: [
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () => _getUserLocation(),
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(49.1974, 16.6088), // počáteční pozice kamery
          zoom: 10, // počáteční přiblížení
        ),
        markers: _markers,
      ),
    );
  }
}