import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _mapState();
}

class _mapState extends State<MapPage> {
 static const CameraPosition initialPosition=CameraPosition(target:LatLng(37.42796133580664, -122.085749655962) ,zoom: 14);
 final Completer<GoogleMapController> _MapCompleterController=Completer<GoogleMapController>();
  GoogleMapController? _controllerGoogleMap;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('emergency map'),
      ),
      body: 
                GoogleMap(
                  mapType: MapType.terrain,
      myLocationEnabled: true,
      initialCameraPosition: initialPosition,
onMapCreated: (GoogleMapController mapController){
_controllerGoogleMap = mapController;

_MapCompleterController.complete(_controllerGoogleMap);
},
                )
               
      
    );
  }
}