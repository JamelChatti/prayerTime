import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapExampleAppPage {
  final CameraPosition _initialPosition;
  final Set<Marker> _markers;
  final Set<Polygon> _polygons;
  final Set<Polyline> _polylines;
  final Set<Circle> _circles;


  GoogleMapExampleAppPage({
    required CameraPosition initialPosition,
    Set<Marker> markers = const {},
    Set<Polygon> polygons = const {},
    Set<Polyline> polylines = const {},
    Set<Circle> circles = const {},
  })  : _initialPosition = initialPosition,
        _markers = markers,
        _polygons = polygons,
        _polylines = polylines,
        _circles = circles;

  CameraPosition get initialPosition => _initialPosition;
  Set<Marker> get markers => _markers;
  Set<Polygon> get polygons => _polygons;
  Set<Polyline> get polylines => _polylines;
  Set<Circle> get circles => _circles;
}
