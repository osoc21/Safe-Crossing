import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'map_screen.dart';

class LocationsScreen extends StatefulWidget {
  LocationsScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _LocationsScreenState createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  List<String> locations = ['Home', 'Work', 'Study'];
  List<IconData> icons = [Icons.home, Icons.work, Icons.school];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _createSizedBox(0, 30),
            Expanded(child: _createLocationsCarousel()),
            _createSizedBox(0, 30),
            Column(
              children: <Widget>[
                _createAddLocationButton(),
                _createSizedBox(0, 10),
                _createMapButton(),
              ],
            ),
            _createSizedBox(0, 30),
          ],
        ),
      ),
    );
  }

  ElevatedButton _createMapButton() {
    return ElevatedButton(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Icon(
            Icons.map,
            size: 25,
          ),
          _createSizedBox(10, 0),
          Text(
            'Map',
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
        ]),
      ),
      onPressed: () {
        Navigator.pushNamed(context, MapScreen.routeName);
      },
    );
  }

  ElevatedButton _createAddLocationButton() {
    return ElevatedButton(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.add_location,
              size: 25,
            ),
            Text(
              'Add New Location',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
      onPressed: () => print('Hello'),
    );
  }

  SizedBox _createSizedBox(double width, double height) {
    return SizedBox(
      height: height,
      width: width,
    );
  }

  CarouselSlider _createLocationsCarousel() {
    return CarouselSlider(
      options: CarouselOptions(),
      items: locations.map((location) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(color: Colors.indigo),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        icons[locations.indexOf(location)],
                        size: 40,
                        color: Colors.white,
                      ),
                      _createSizedBox(15, 0),
                      Text(
                        '$location',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 30.0),
                      )
                    ]));
          },
        );
      }).toList(),
    );
  }
}
