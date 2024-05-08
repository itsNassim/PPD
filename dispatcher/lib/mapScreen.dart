import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  map createState() => map();
}

class map extends State<MapScreen> {
  Position? _currentPosition;
  final MapController _mapController = MapController();
  Color primary = const Color.fromARGB(255, 62, 99, 137);
  double zoom = 20;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.deniedForever) {
      // The user has permanently denied location permission. You can prompt them to go to settings and enable it manually.
      return;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // Permission not granted, exit method
        return;
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
      });

      // Adjust map position according to the retrieved location
      if (_mapController != null && _currentPosition != null) {
        _mapController.move(
          LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          _mapController.zoom,
        );
      }
    } catch (e) {
      // Handle exceptions
      print("Error getting location: $e");
      // You can provide feedback to the user here if needed.
    }
  }

  void _zoomIn() {
    _mapController.move(_mapController.center, _mapController.zoom + 1);
  }

  void _zoomOut() {
    _mapController.move(_mapController.center, _mapController.zoom - 1);
  }

  Widget content() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Map',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(62, 99, 137, 1)),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  center: _currentPosition != null
                      ? LatLng(
                          _currentPosition!.latitude,
                          _currentPosition!.longitude,
                        )
                      : const LatLng(28.0289837, 1.6666663),
                  zoom: zoom,
                  interactionOptions: const InteractionOptions(
                    flags: ~InteractiveFlag.doubleTapDragZoom,
                  ),
                ),
                children: [
                  openStreetMapTileLayer,
                  MarkerLayer(
                    markers: _currentPosition != null
                        ? [
                            Marker(
                              point: LatLng(
                                _currentPosition!.latitude,
                                _currentPosition!.longitude,
                              ),
                              width: 60,
                              height: 60,
                              alignment: Alignment.centerLeft,
                              child: const Icon(
                                Icons.location_pin,
                                size: 60,
                                color: Colors.red,
                              ),
                            ),
                          ]
                        : [],
                  ),
                ],
              ),
              Positioned(
                bottom: 16.0,
                right: 16.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      onPressed: _zoomIn,
                      backgroundColor: primary,
                      foregroundColor: Color.fromARGB(255, 205, 205, 205),
                      child: const Icon(Icons.add),
                    ),
                    const SizedBox(height: 8.0),
                    FloatingActionButton(
                      onPressed: _zoomOut,
                      backgroundColor: primary,
                      foregroundColor: Color.fromARGB(255, 205, 205, 205),
                      child: const Icon(Icons.remove),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: content(),
    );
  }
}

TileLayer get openStreetMapTileLayer => TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
    );
