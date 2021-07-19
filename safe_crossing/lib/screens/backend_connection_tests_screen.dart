import 'dart:developer';

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
  late IO.Socket socket;

  String message = "You are not connected to the socket";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Backend"),
      ),
      body: Column(children: [
        Text(message),
        ElevatedButton(
            onPressed: connectToSocket, child: Text("Connect to socket")),
        ElevatedButton(
            onPressed: disconnectFromSocket,
            child: Text("Dissconnect from socket"))
      ]),
    );
  }

  void connectToSocket() {
    //IO.Socket socket;
    socket = IO.io(
      'http://localhost:3000',
      <String, dynamic>{
        'transports': ['websocket']
      },
    );

    socket.onConnect((data) {
      this.message = "Connected to server socket";
    });

    socket.emit('from_client', "Hello from client");
  }

  void disconnectFromSocket() {
    this.message = "disconnected from socket";
    socket.dispose();
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
