import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; // Updated import
import 'package:geolocator/geolocator.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Position? _currentPosition;
  final MapController _mapController = MapController();
  double zoom = 15; // Adjust the initial zoom level here

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = position;
    });

    _mapController.move(
      LatLng(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      ),
      _mapController.zoom,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        toolbarHeight: 60.0,
        title: const Text(
          'AIDNOW MAP',
          style: TextStyle(
            fontSize: 24,
            color: Colors.black87,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: _currentPosition != null
                  ? LatLng(
                      _currentPosition!.latitude, _currentPosition!.longitude)
                  : LatLng(28.0289837, 1.6666663),
              zoom: zoom,
              interactionOptions: const InteractionOptions(
                  flags: ~InteractiveFlag.doubleTapDragZoom),
            ),
            children: [
              openStreetMapTileLayer,
              if (_currentPosition != null)
                MarkerLayer(markers: [
                  Marker(
                      point: LatLng(_currentPosition!.latitude,
                          _currentPosition!.longitude),
                      width: 60,
                      height: 60,
                      alignment: Alignment.centerLeft,
                      child: const Icon(
                        Icons.location_pin,
                        size: 60,
                        color: Colors.red,
                      ))
                ])
            ],
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: _getCurrentLocation,
                  child: const Icon(Icons.my_location),
                  backgroundColor: const Color.fromARGB(255, 59, 117, 233),
                ),
                const SizedBox(height: 8.0),
                FloatingActionButton(
                  onPressed: _zoomIn,
                  child: const Icon(Icons.add),
                  backgroundColor: const Color.fromARGB(255, 59, 117, 233),
                ),
                const SizedBox(height: 8.0),
                FloatingActionButton(
                  onPressed: _zoomOut,
                  child: const Icon(Icons.remove),
                  backgroundColor: const Color.fromARGB(255, 59, 117, 233),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _zoomIn() {
    _mapController.move(_mapController.center, _mapController.zoom + 1);
  }

  void _zoomOut() {
    _mapController.move(_mapController.center, _mapController.zoom - 1);
  }
}

TileLayer get openStreetMapTileLayer => TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
    );
