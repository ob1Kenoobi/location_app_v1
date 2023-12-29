import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:google_maps_app/utils/map_utils.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;
  List<LatLng> _polylineCoordinates = [];
  Set<Polyline> _polylines = {};
  MarkerId _markerId = MarkerId("marker");
  Marker _marker = const Marker(markerId: MarkerId("marker"));

  int _iterationCount = 0;
  LatLng _currentLatLng = LatLng(0.0, 0.0);

  @override
  void initState() {
    super.initState();
    _initLocationTracking();
  }

  Future<void> _initLocationTracking() async {
    const duration = Duration(seconds: 5);
    Timer.periodic(duration, (Timer t) {
      if (_iterationCount < 4) {
        moveUserRandomly();
        _iterationCount++;
      } else {
        t.cancel();
      }
    });

    moveUserRandomly();
  }

  void moveUserRandomly() {
    final LatLng newLocation = getRandomLocation();
    updateMarkerAndPolyline(newLocation);
  }

  void updateMarkerAndPolyline(LatLng location) {
    setState(() {
      _marker = Marker(
        markerId: _markerId,
        position: location,
        onTap: () {
          _controller?.showMarkerInfoWindow(_markerId);
        },
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
          title: "My current location",
          snippet: "${location.latitude},${location.longitude}",
        ),
      );

      _polylineCoordinates.add(location);
      _currentLatLng = location;

      _polylines = {
        Polyline(
          polylineId: const PolylineId("polyline"),
          points: _polylineCoordinates,
          color: Colors.blue,
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
        title: const Text('Location Tracking App'),
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
              initialCameraPosition: const CameraPosition(
                target: LatLng(0.0, 0.0),
                zoom: 15,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Current Location:  ${_currentLatLng.latitude},${_currentLatLng.longitude}',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
