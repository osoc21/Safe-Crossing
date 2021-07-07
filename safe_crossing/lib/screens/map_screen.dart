import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

const double CAMERA_ZOOM = 30;
const double CAMERA_TILT = 0;
const double CAMERA_BEARING = 30;
const PointLatLng SOURCE_LOCATION = PointLatLng(45.521563, -122.677433);
const PointLatLng DEST_LOCATION = PointLatLng(45.521563, -122.687433);

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

  // Route drawing
  Completer<GoogleMapController> _controller = Completer();
  // this set will hold my markers
  Set<Marker> _markers = {};
  // this will hold the generated polylines
  Set<Polyline> _polylines = {};
  // this will hold each polyline coordinate as Lat and Lng pairs
  List<LatLng> polylineCoordinates = [];
  // this is the key object - the PolylinePoints
  // which generates every polyline between start and finish
  PolylinePoints polylinePoints = PolylinePoints();

  @override
  void initState() {
    super.initState();
    setSourceAndDestinationIcons();
  }

  void setSourceAndDestinationIcons() async {
    Icon sourceIcon = Icon(Icons.person);
    Icon destinationIcon = Icon(Icons.check_circle);
  }

  void setMapPins() {
    setState(() {
      // source pin
      _markers.add(
        Marker(
          markerId: MarkerId('sourcePin'),
          position: LatLng(SOURCE_LOCATION.latitude, SOURCE_LOCATION.longitude),
        ),
      );
      // destination pin
      _markers.add(
        Marker(
          markerId: MarkerId('destPin'),
          position: LatLng(DEST_LOCATION.latitude, DEST_LOCATION.longitude),
        ),
      );
    });
  }

  setPolylines() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyBIiQWhcafuBg-tx6P0wQ5q8QvpZx0RsHE',
      SOURCE_LOCATION,
      DEST_LOCATION,
      travelMode: TravelMode.walking,
    );
    if (result.points.isNotEmpty) {
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      print("not empty");
    }
    setState(() {
      // create a Polyline instance
      // with an id, an RGB color and the list of LatLng pairs
      Polyline polyline = Polyline(
          polylineId: PolylineId("poly"),
          color: Color.fromARGB(255, 40, 122, 198),
          points: polylineCoordinates);

      // add the constructed polyline as a set of points
      // to the polyline set, which will eventually
      // end up showing up on the map
      _polylines.add(polyline);
    });
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    setMapPins();
    await setPolylines();
    _location.onLocationChanged.listen((l) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(
                l.latitude ?? _initialcameraposition.latitude,
                l.longitude ?? _initialcameraposition.longitude,
              ),
              zoom: CAMERA_ZOOM),
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
                markers: _markers,
                polylines: _polylines,
                myLocationEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: CAMERA_ZOOM,
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
