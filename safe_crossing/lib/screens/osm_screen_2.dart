import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class OSMScreen2 extends StatefulWidget {
  static const routeName = '/osm-screen-2';
  @override
  _OSMScreen2State createState() => _OSMScreen2State();
}

class _OSMScreen2State extends State<OSMScreen2> {
  late List<MapLatLng> polyline;
  late List<List<MapLatLng>> polylines;
  late MapZoomPanBehavior zoomPanBehavior;

  @override
  void initState() {
    polyline = <MapLatLng>[
      MapLatLng(13.0827, 80.2707),
      MapLatLng(13.1746, 79.6117),
      MapLatLng(13.6373, 79.5037),
      MapLatLng(14.4673, 78.8242),
      MapLatLng(14.9091, 78.0092),
      MapLatLng(16.2160, 77.3566),
      MapLatLng(17.1557, 76.8697),
      MapLatLng(18.0975, 75.4249),
      MapLatLng(18.5204, 73.8567),
      MapLatLng(19.0760, 72.8777),
    ];

    polylines = <List<MapLatLng>>[polyline];
    zoomPanBehavior = MapZoomPanBehavior(
      zoomLevel: 5,
      focalLatLng: MapLatLng(20.3173, 78.7139),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OSM Screen 2"),
      ),
      body: Center(
        child: SfMaps(
          layers: [
            MapTileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              sublayers: [
                MapPolylineLayer(
                  polylines: List<MapPolyline>.generate(
                    polylines.length,
                    (int index) {
                      return MapPolyline(
                        points: polylines[index],
                      );
                    },
                  ).toSet(),
                ),
              ],
              zoomPanBehavior: zoomPanBehavior,
            ),
          ],
        ),
      ),
    );
  }
}
