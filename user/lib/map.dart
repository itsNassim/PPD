import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; // Updated import statement
import 'package:geolocator/geolocator.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _mapState();
}

class _mapState extends State<MapPage> {
  Position? _currentPosition; // Initialize _currentPosition to null
  final MapController _mapController = MapController();
  double zoom = 20;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // Method to get the current location
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
        _currentPosition!.latitude - 1.0651983,
        _currentPosition!.longitude + 128.7245,
      ),
      _mapController.zoom,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text("Map page"),
      ),
      body: Stack(
        children: [
          content(),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: _zoomIn,
                  child: Icon(Icons.add),
                ),
                SizedBox(height: 8.0),
                FloatingActionButton(
                  onPressed: _zoomOut,
                  child: Icon(Icons.remove),
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

  Widget content() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        center: _currentPosition != null
            ? LatLng(_currentPosition!.latitude - 1.0651983,
                _currentPosition!.longitude + 128.7245)
            : LatLng(28.0289837, 1.6666663),
        zoom: zoom,
        interactionOptions:
            const InteractionOptions(flags: ~InteractiveFlag.doubleTapDragZoom),
      ),
      children: [
        openStreetMapTileLayer,
        MarkerLayer(markers: [
          Marker(
              point: _currentPosition != null
                  ? LatLng(_currentPosition!.latitude - 1.0651983,
                      _currentPosition!.longitude + 128.7245)
                  : LatLng(28.0289837, 1.6666663),
              width: 60,
              height: 60,
              alignment: Alignment.centerLeft,
              child: Icon(
                Icons.location_pin,
                size: 60,
                color: Colors.red,
              ))
        ])
      ],
    );
  }
}

TileLayer get openStreetMapTileLayer => TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
    );


//36.24621367246233, 6.570038483333845 univ 2