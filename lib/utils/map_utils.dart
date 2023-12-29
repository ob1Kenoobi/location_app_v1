import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';


LatLng getRandomLocation() {
  final random = Random();
  final double latitude = 40.7128 + (random.nextDouble() - 0.5) * 0.01;
  final double longitude = -74.0060 + (random.nextDouble() - 0.5) * 0.01;

  return LatLng(latitude, longitude);
}
