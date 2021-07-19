import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class BackendConnectionTestsScreen extends StatefulWidget {
  static const routeName = '/bect-screen';

  @override
  _BackendConnectionTestsScreenState createState() =>
      _BackendConnectionTestsScreenState();
}

class _BackendConnectionTestsScreenState
    extends State<BackendConnectionTestsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Backend"),
      ),
      body: Center(child: Text('Backend connection here')),
    );
  }
}

class Coordinates {
  final double longitude;
  final double latitude;

  Coordinates({
    required this.longitude,
    required this.latitude,
  });

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
      longitude: json['long'],
      latitude: json['lat'],
    );
  }
}

class MapData {
  final int id;
  final Coordinates coordinates;

  MapData({
    required this.id,
    required this.coordinates,
  });

  factory MapData.fromJson(Map<String, dynamic> json) {
    return MapData(
      id: json['id'],
      coordinates: json['coordinates'],
    );
  }
}
