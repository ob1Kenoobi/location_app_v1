import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:math'; // Import for generating random numbers

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;
  List<LatLng> _polylineCoordinates = [];
  Set<Polyline> _polylines = {};
  MarkerId _markerId = MarkerId("marker");
  Marker _marker = Marker(markerId: MarkerId("marker"));

  int _iterationCount = 0; // Counter to track the number of iterations
  LatLng _currentLatLng = LatLng(0.0, 0.0); // Variable to store current latitude and longitude

  @override
  void initState() {
    super.initState();
    _initLocationTracking();
  }

  Future<void> _initLocationTracking() async {
    const duration = Duration(seconds: 5);
    Timer.periodic(duration, (Timer t) {
      if (_iterationCount < 4) {
        _moveUserRandomly();
        _iterationCount++;
      } else {
        t.cancel(); // Stop the timer after 4 iterations
      }
    });

    _moveUserRandomly(); // Initial random location
  }

  void _moveUserRandomly() {
    final random = Random();
    final double latitude = 40.7128 + (random.nextDouble() - 0.5) * 0.005; // Random latitude within range
    final double longitude = -74.0060 + (random.nextDouble() - 0.5) * 0.005; // Random longitude within range

    final LatLng newLocation = LatLng(latitude, longitude);
    _updateMarkerAndPolyline(newLocation);
  }

  void _updateMarkerAndPolyline(LatLng location) {
    setState(() {
      _marker = Marker(
        markerId: _markerId,
        position: location,
        onTap: () {
          _controller?.showMarkerInfoWindow(_markerId);
        },
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
        infoWindow: InfoWindow(
          title: "My current location:",
          snippet: "${location.latitude},${location.longitude}",
        ),
      );

      _polylineCoordinates.add(location);
      _currentLatLng = location; // Update the current latitude and longitude

      _polylines = {
        Polyline(
          polylineId: PolylineId("polyline"),
          points: _polylineCoordinates,
          color: Colors.purple,
          width: 5,
        ),
      };

      if (_controller != null) {
        _controller!.animateCamera(CameraUpdate.newLatLng(location));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Tracking App'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                setState(() {
                  _controller = controller;
                });
              },
              markers: {_marker},
              polylines: _polylines,
              initialCameraPosition: CameraPosition(
                target: LatLng(0.0, 0.0),
                zoom: 15,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Current Location: ${_currentLatLng.latitude}, ${_currentLatLng.longitude}',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}



