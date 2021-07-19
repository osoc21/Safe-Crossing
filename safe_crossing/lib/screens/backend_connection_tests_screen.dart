import 'package:flutter/material.dart';
// Backend
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

class BackendConnectionTestsScreen extends StatefulWidget {
  static const routeName = '/bect-screen';

  @override
  _BackendConnectionTestsScreenState createState() =>
      _BackendConnectionTestsScreenState();
}

class _BackendConnectionTestsScreenState
    extends State<BackendConnectionTestsScreen> {
//  final _channel = WebSocketChannel.connect(
//    Uri.parse('http://localhost:3000/api/data/getSimulation'),
//  );

  Future<String> fetchData() async {
    print("fetchData() called");
    http.BaseRequest request = http.BaseRequest(
      "GET",
      Uri.parse('http://127.0.0.1:3000/api/data/getSimulation'),
    );
    var streamedResponse = await http.BaseRequest.send();
    var response = await http.Response.fromStream(streamedResponse);

    final response = await http.get(
      Uri.parse('http://127.0.0.1:3000/api/data/getSimulation'),
      headers: {"Content-type": "application/json"},
    );
    print("response: ${response}");
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return response.body;
//      return Album.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    }
  }

  late Future<String> futureText;

  @override
  void initState() {
    super.initState();
    print("initState() called");
    futureText = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Backend"),
      ),
      body: Center(
        child: FutureBuilder<String>(
          future: futureText,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        ),
      ),
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
