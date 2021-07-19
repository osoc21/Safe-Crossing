import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';

class OSMScreen extends StatefulWidget {
  static const routeName = '/osm-screen';

  @override
  _OSMScreenState createState() => _OSMScreenState();
}

class _OSMScreenState extends State<OSMScreen> {
  final PopupController _popupController = PopupController();
  MapController _mapController = MapController();
  double _zoom = 7;
  List<LatLng> _latLngList = [
    LatLng(13, 77.5),
    LatLng(13.02, 77.51),
  ];

  List<Marker> _markers = [];

  @override
  void initState() {
    _markers = _latLngList
        .map((point) => Marker(
              point: point,
              width: 60,
              height: 60,
              builder: (context) => Icon(
                Icons.pin_drop,
                size: 60,
                color: Colors.blueAccent,
              ),
            ))
        .toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OSM Screen'),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: _latLngList[0],
          bounds: LatLngBounds.fromPoints(_latLngList),
          zoom: _zoom,
          plugins: [
            MarkerClusterPlugin(),
          ],
          onTap: (_) => _popupController.hidePopup(),
        ),
        layers: [
          TileLayerOptions(
            minZoom: 2,
            maxZoom: 18,
            backgroundColor: Colors.black,
            // errorImage: ,
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerClusterLayerOptions(
            maxClusterRadius: 190,
            disableClusteringAtZoom: 16,
            size: Size(50, 50),
            fitBoundsOptions: FitBoundsOptions(
              padding: EdgeInsets.all(50),
            ),
            markers: _markers,
            polygonOptions: PolygonOptions(
                borderColor: Colors.blueAccent,
                color: Colors.black12,
                borderStrokeWidth: 3),
            popupOptions: PopupOptions(
                popupSnap: PopupSnap.mapTop,
                popupController: _popupController,
                popupBuilder: (_, marker) => Container(
                      color: Colors.amberAccent,
                      child: Text('Popup'),
                    )),
            builder: (context, markers) {
              return Container(
                alignment: Alignment.center,
                decoration:
                    BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                child: Text('${markers.length}'),
              );
            },
          ),
          PolylineLayerOptions(polylines: [
            Polyline(
              points: _latLngList,
              strokeWidth: 5.0,
              color: Colors.red,
            )
          ]),
        ],
      ),
    );
  }
}
