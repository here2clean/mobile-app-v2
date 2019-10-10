import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:core';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:here_to_clean_v2/constants/h2c_api_routes.dart';
import 'package:here_to_clean_v2/httpClients/H2CHttpClient.dart';
import 'package:here_to_clean_v2/model/Event.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

class UniqueMapView extends StatefulWidget {
  final String token;
  final Event event;

  UniqueMapView({this.token, this.event});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _UniqueMapViewState(token: token, event: event);
  }
}

class _UniqueMapViewState extends State<UniqueMapView> {
  final String token;
  final Event event;

  Set<Marker> _markers = new Set<Marker>();
  Future _future;

  _UniqueMapViewState({this.token, this.event});

  CameraPosition _defaultPos =
      new CameraPosition(target: LatLng(48.856613, 2.352222), zoom: 15);
  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Card(
      child: FutureBuilder(
          future: setMapDisplay(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return GoogleMap(
                  initialCameraPosition: snapshot.data["cameraPosition"],
                  mapType: MapType.normal,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  markers: snapshot.data["markers"]);
            }
          }),
    ));
  }

  @override
  void initState() {
    _askForLocationPermission();
    super.initState();
  }

  Future<HashMap<String, Object>> setMapDisplay() async {
    Set<Marker> markers = new Set<Marker>();

    Marker marker = await eventToMarker(this.event);
    markers.add((marker));

    CameraPosition cameraPosition = CameraPosition(
        target: LatLng(
          marker.position.latitude,
          marker.position.longitude,
        ),
        zoom: 15);
    HashMap<String, Object> output = new HashMap<String, Object>();
    output.addEntries([
      MapEntry("cameraPosition", cameraPosition),
      MapEntry("markers", markers)
    ]);
    return output;
  }

  Future<Marker> eventToMarker(Event event) async {
    Marker output = await Geocoder.local
        .findAddressesFromQuery(event.location)
        .then((values) => Marker(
            markerId: MarkerId(event.id.toString()),
            position: LatLng(values.first.coordinates.latitude,
                values.first.coordinates.longitude),
            infoWindow: InfoWindow(title: event.location)));

    return output;
  }

  void _askForLocationPermission() async {
    Map<PermissionGroup, PermissionStatus> permissions;
    permissions = await PermissionHandler().requestPermissions([
      PermissionGroup.location,
    ]);
  }
}
