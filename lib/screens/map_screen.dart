import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class MapSample extends StatefulWidget {
  @override
  _MapSampleState createState() => _MapSampleState();
}

class _MapSampleState extends State<MapSample> {
  late GoogleMapController _controller;
  List<Marker> _markers = [];
  Marker? _userMarker;

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }
  }

  bool hasRequestedPermission = false;

  @override
  void initState() {
    super.initState();
    if (!hasRequestedPermission) {
      _requestLocationPermission();
      hasRequestedPermission = true;
    }
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      await _requestLocationPermission();
    }

    Position position = await Geolocator.getCurrentPosition();
    LatLng userLatLng = LatLng(position.latitude, position.longitude);

    if (_userMarker == null) {
      // create new marker if one does not exist
      _userMarker = Marker(
        markerId: MarkerId('user'),
        position: userLatLng,
        infoWindow: InfoWindow(title: 'Moje poloha'),
      );
      _markers.add(_userMarker!);
    } else {
      // update existing marker position
      _userMarker = _userMarker!.copyWith(positionParam: userLatLng);
    }

    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: userLatLng,
        zoom: 25,
      ),
    ));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Mapa'),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () => _getUserLocation(),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('pamatky').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          _markers.clear();

          snapshot.data!.docs.forEach((doc) {
            var position = LatLng(
              doc['location'].latitude,
              doc['location'].longitude,
            );

            var marker = Marker(
              markerId: MarkerId(doc.id),
              position: position,
              infoWindow: InfoWindow(
                title: doc['name'],
                // snippet: doc['description'],
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen,
              ),
            );

            _markers.add(marker);
          });

          if (_userMarker != null) {
            _markers.add(_userMarker!);
          };

          return GoogleMap(
            onMapCreated: (controller) => _controller = controller,
            initialCameraPosition: CameraPosition(
              target: LatLng(49.1974, 16.6088), // default location
              zoom: 10.0, // default zoom
            ),
            markers: Set<Marker>.of(_markers),
          );
        },
      ),
    );
  }
}