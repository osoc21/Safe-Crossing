import 'package:flutter/material.dart';
import 'map_screen.dart';

class LocationsScreen extends StatefulWidget {
  LocationsScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _LocationsScreenState createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
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
            ElevatedButton(
                child: Text('Say'),
                onPressed: () {
                  Navigator.pushNamed(context, MapScreen.routeName);
                })
          ],
        ),
      ),
    );
  }
}
