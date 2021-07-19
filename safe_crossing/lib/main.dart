import 'package:flutter/material.dart';
import 'package:safe_crossing/screens/backend_connection_tests_screen.dart';
import 'screens/locations_screen.dart';
import 'screens/map_screen.dart';
import 'package:safe_crossing/screens/osm_screen.dart';
import 'package:safe_crossing/screens/osm_screen_2.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Safe Crossing',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      routes: {
//        '/': (ctx) => LocationsScreen(
//              title: 'Safe Crossing',
//            ),
        '/': (ctx) => OSMScreen2(),
        OSMScreen2.routeName: (ctx) => OSMScreen2(),
//        '/': (ctx) => BackendConnectionTestsScreen(),
//        BackendConnectionTestsScreen.routeName: (ctx) =>
//            BackendConnectionTestsScreen(),
      },
    );
  }
}
