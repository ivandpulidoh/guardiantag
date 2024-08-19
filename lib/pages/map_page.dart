import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_yt/consts.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Location _locationController = new Location();

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  static const LatLng _pGooglePlex = LatLng(4.7204089122285735, -74.22887251784213);
  static const LatLng _pApplePark = LatLng(4.720491399788873, -74.22881048171202);
  LatLng? _currentP = null;

  Map<PolylineId, Polyline> polylines = {};

  BitmapDescriptor sourcecIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  void setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty, "assets/images/dog1.png")
    .then(
      (icon){
        sourcecIcon = icon;
      },
    );
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty, "assets/images/dog2.png")
    .then(
      (icon){
        destinationIcon = icon;
      },
    );
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty, "assets/images/user1.png")
    .then(
      (icon){
        currentLocationIcon = icon;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    setCustomMarkerIcon();
    getLocationUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Track DOG",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: _currentP == null
          ? const Center(
              child: Text("Loading..."),
            )
          : GoogleMap(
              onMapCreated: ((GoogleMapController controller) =>
                  _mapController.complete(controller)),
              initialCameraPosition: CameraPosition(
                target: _currentP!,
                zoom: 50,
              ),
              markers: {
                Marker(
                  markerId: MarkerId("_currentLocation"),
                  icon: currentLocationIcon,
                  position: _currentP!,
                ),
                Marker(
                    markerId: MarkerId("_sourceLocation"),
                    icon: sourcecIcon,
                    position: _pGooglePlex),
                Marker(
                    markerId: MarkerId("_destionationLocation"),
                    icon: destinationIcon,
                    position: _pApplePark)
              },
              circles: {
                Circle(circleId: CircleId("1"),
                center: _currentP!,
                radius: 10,
                strokeWidth: 2,
                fillColor: Color(0xFF006491).withOpacity(0.2),
                )
              },
              polylines: Set<Polyline>.of(polylines.values),
            ),
    );
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(
      target: pos,
      zoom: 75,
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(_newCameraPosition),
    );
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentP =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          _cameraToPosition(_currentP!);
        });
      }
    });
  }

  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      GOOGLE_MAPS_API_KEY,
      PointLatLng(_pGooglePlex.latitude, _pGooglePlex.longitude),
      PointLatLng(_pApplePark.latitude, _pApplePark.longitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    return polylineCoordinates;
  }

  void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) async {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.black,
        points: polylineCoordinates,
        width: 8);
    setState(() {
      polylines[id] = polyline;
    });
  }
}
