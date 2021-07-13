import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class OSMScreen extends StatefulWidget {
  static const routeName = '/osm-screen';

  @override
  _OSMScreenState createState() => _OSMScreenState();
}

class _OSMScreenState extends State<OSMScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OSM"),
      ),
      body: Center(),
    );
  }
}
