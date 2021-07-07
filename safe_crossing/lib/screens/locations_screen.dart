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
  List<String> titles = ['Home', 'Work', 'Study'];
  List<IconData> icons = [Icons.home, Icons.work, Icons.school];

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
            Expanded(
              child: ListView.builder(
                itemCount: titles.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: Icon(icons[index]),
                      title: Text('${titles[index]}'),
                      trailing: Icon(Icons.keyboard_arrow_right),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              child: Text('Say'),
              onPressed: () {
                Navigator.pushNamed(context, MapScreen.routeName);
              },
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
