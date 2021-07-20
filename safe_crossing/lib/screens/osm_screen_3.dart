import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class OSMScreen3 extends StatefulWidget {
  static const routeName = '/osm-screen-3';
  @override
  _OSMScreen3State createState() => _OSMScreen3State();
}

class _OSMScreen3State extends State<OSMScreen3> {
  GlobalKey<OSMFlutterState> mapKey = GlobalKey<OSMFlutterState>();

  MapController controller = MapController(
    initMapWithUserPosition: false,
    initPosition: GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
  );

  drawRoadOnMap() async {
    try {
      await mapKey.currentState.drawRoad(
          GeoPoint(latitude: 28.596429, longitude: 77.190628),
          GeoPoint(latitude: 28.4573802, longitude: 73.1424312));
    } on RoadException catch (e) {
      print("${e.errorMessage()}");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: OSMFlutter(
        controller: controller,
        trackMyPosition: false,
        road: Road(
          startIcon: MarkerIcon(
            icon: Icon(
              Icons.person,
              size: 64,
              color: Colors.brown,
            ),
          ),
          roadColor: Colors.yellowAccent,
        ),
        markerOption: MarkerOption(
          defaultMarker: MarkerIcon(
            icon: Icon(
              Icons.person_pin_circle,
              color: Colors.blue,
              size: 56,
            ),
          ),
        ),
      ),
    );
  }
}
