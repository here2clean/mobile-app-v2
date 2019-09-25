import 'dart:async';
import 'dart:core';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:here_to_clean_v2/model/Event.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';

class MapView extends StatefulWidget {
  final String token;
  MapView(this.token);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new MapViewState(token);
  }
}

class MapViewState extends State<MapView> {
  final String token;
  MapViewState({this.token});
  static final CameraPosition _defaultPos =
      new CameraPosition(target: LatLng(52.509738, 13.460175), zoom: 15);
  Completer<GoogleMapController> _controller = Completer();
  Location _location = new Location();
  static BitmapDescriptor _icon;
  Set<Marker> _markers;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GoogleMap(
        initialCameraPosition: _defaultPos,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: eventListToMarkerSet(events));
  }

  @override
  void initState() {

    super.initState();
  }

  Set<Marker> eventListToMarkerSet(List<Event> events) {
    return Set<Marker>.from(events.map((e) => eventToMarker(e)));
  }

  Marker eventToMarker(Event event) {
    Marker output;
    Geocoder.local.findAddressesFromQuery(event.location).then((values) =>
        output = Marker(
            markerId: MarkerId(""),
            position: LatLng(values.first.coordinates.latitude,
                values.first.coordinates.longitude),
            infoWindow: InfoWindow(title: event.name)));
    return output;
  }
}
