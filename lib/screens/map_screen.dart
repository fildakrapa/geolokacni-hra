import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class MapSample extends StatefulWidget {
  @override
  _MapSampleState createState() => _MapSampleState();

}


class _MapSampleState extends State<MapSample> {
  late GoogleMapController _controller;
  List<Marker> _markers = [];

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  Future<void> _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    Marker userMarker = Marker(
      markerId: MarkerId('user'),
      position: LatLng(position.latitude, position.longitude),
      infoWindow: InfoWindow(title: 'Moje poloha'),
    );
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
          ]
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

          return GoogleMap(
            onMapCreated: _onMapCreated,
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