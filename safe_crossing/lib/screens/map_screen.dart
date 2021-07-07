import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  static const routeName = '/map-screen';

  MapScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Google map
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(45.521563, -122.677433);

  // User Location
  LatLng _initialcameraposition = LatLng(45.521563, -122.687433);
  Location _location = Location();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _location.onLocationChanged.listen((l) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(
                l.latitude ?? _initialcameraposition.latitude,
                l.longitude ?? _initialcameraposition.longitude,
              ),
              zoom: 25),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 11.0,
                ),
              ),
            ),
            ElevatedButton(
              child: Container(
                height: 300,
                width: double.infinity,
                child: Center(
                  child: Text(
                    'Voice',
                    style: TextStyle(fontSize: 50),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              onPressed: () {},
            ),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
