import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safe_crossing/models/traffic_light.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class TrafficLightProximityScreen extends StatefulWidget {
  static const routeName = '/traffic-light-proximity';

  @override
  _TrafficLightProximityScreenState createState() =>
      _TrafficLightProximityScreenState();
}

class _TrafficLightProximityScreenState
    extends State<TrafficLightProximityScreen> {
  bool _isScriptRunning = false;
  Color _trafficLightColor = Colors.grey;
  String _trafficLightId = "Not close to a traffic light";
  bool _isSocketConnected = false;
  late IO.Socket socket;

  @override
  void initState() {
    handleSocketConnection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Traffic Light Proximity"),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              Expanded(
                  child: Card(
                color: _trafficLightColor,
                child: SizedBox.expand(
                  child: Center(
                      child: Text(_trafficLightId,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold))),
                ),
              )),
              ElevatedButton(
                  onPressed: !_isScriptRunning ? runLocalizationScript : null,
                  child: Center(child: Text("Run localization script"))),
              ElevatedButton(
                  onPressed: _isScriptRunning ? stopLocalizationScript : null,
                  child: Center(child: Text("Stop localization script"))),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: _isSocketConnected ? disconnectSocket : null,
                        child: Center(
                            child: Text(
                          "Disconnect from the socket",
                          textAlign: TextAlign.center,
                        ))),
                  ),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: !_isSocketConnected ? connectSocket : null,
                        child: Center(
                            child: Text("Connect to the socket",
                                textAlign: TextAlign.center))),
                  )
                ],
              )
            ])));
  }

  void disconnectSocket() {
    socket.disconnect();
    socket.close();

    setState(() {
      _isSocketConnected = false;
    });
  }

  void connectSocket() {
    socket.connect();

    socket.emit('from_client', "Hello from client");
  }

  void handleSocketConnection() {
    socket = IO.io(
      'http://localhost:3000',
      <String, dynamic>{
        'transports': ['websocket'],
        "autoConnect": false
      },
    );

    socket.onConnect((data) {
      print("Connected to the server");
      setState(() {
        _isSocketConnected = true;
      });
    });

    socket.on(
        'pozyx_data',
        (data) => {
              if (data != "Null")
                {
                  setState(() {
                    print(data);
                    Map<String, dynamic> trafficLightJson = jsonDecode(data);
                    var trafficLight = TrafficLight.fromJson(trafficLightJson);
                    _trafficLightId = trafficLight.id;
                    _trafficLightColor = trafficLight.status == "Red"
                        ? Colors.red
                        : Colors.green;
                  })
                }
              else
                {
                  setState(() {
                    _trafficLightId = "Not close to a traffic light";
                    _trafficLightColor = Colors.grey;
                  })
                }
            });
  }

  void runLocalizationScript() {
    print("Run the localization script");
    setState(() {
      _isScriptRunning = true;
    });
    socket.emit('run script');
  }

  void stopLocalizationScript() {
    print("Stop the localization script");
    setState(() {
      _isScriptRunning = false;
    });
    socket.emit('stop script');
  }
}
