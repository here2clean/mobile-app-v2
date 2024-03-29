import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:here_to_clean_v2/constants/h2c_api_routes.dart';
import 'package:here_to_clean_v2/httpClients/H2CHttpClient.dart';
import 'package:here_to_clean_v2/model/Event.dart';
import 'package:geocoder/geocoder.dart';
import 'package:here_to_clean_v2/model/volunteer.dart';
import 'package:here_to_clean_v2/pages/detail_event_page.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

class MapView extends StatefulWidget {
  final String token;
  final Volunteer volunteer;
  final Map<String, String> filters;

  MapView({this.token, this.volunteer, this.filters});

  @override
  State<StatefulWidget> createState() {
    return new _MapViewState(token: token, volunteer:volunteer, filters:  filters);
  }
}

class _MapViewState extends State<MapView> {
  final String token;
  final Volunteer volunteer;
  final Map<String, String> filters;

  _MapViewState({this.token, this.volunteer, this.filters});

  CameraPosition _defaultPos =
      new CameraPosition(target: LatLng(48.856613, 2.352222), zoom: 15);
  Completer<GoogleMapController> _controller = Completer();

  static List<Event> parseEvents(String responseBody, Map<String, String> filters) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    List<Event> events = parsed.map<Event>((json) => Event.fromJson(json)).toList();
    events = events.where((e) => (e.endDate.isAfter(DateTime.now())|| filters["filterByDate"] == "false")).toList();
    return events;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: setMapDisplay(),
            builder: (context, AsyncSnapshot snapshot) {
              if(snapshot.hasError){
                throw snapshot.error;
              }
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
    );
  }

  @override
  void initState() {
    _askForLocationPermission();
    super.initState();
  }

  Future<HashMap<String, Object>> setMapDisplay() async {
    List<Event> events = await fetchEvent(H2CHttpClient(token: token));
    Set<Marker> markers = new Set<Marker>();
    for (var event in events) {
      Marker marker = await eventToMarker(event);
      markers.add((marker));
    }
    CameraPosition cameraPosition = await getUsersCameraPosition();
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
            infoWindow: InfoWindow(title: event.name),
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailEventPage(
                        event: event, token: token, volunteer: volunteer,)))

            }));

    return output;
  }

  Future<List<Event>> fetchEvent(H2CHttpClient client) async {
    final response = await client.get(H2CApiRoutes.getAllEvents);

    if (response.statusCode == 200) {
      return parseEvents(response.body, filters);
    } else {
      throw new Exception(response.statusCode);
    }
  }

  void _askForLocationPermission() async {
    Map<PermissionGroup, PermissionStatus> permissions;
    permissions = await PermissionHandler().requestPermissions([
      PermissionGroup.location,
    ]);
  }

  Future<CameraPosition> getUsersCameraPosition() async {
    var location = new Location();
    try {
      var currentLocation = await location.getLocation();
      return new CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: 10);
    } catch (e) {
      return new CameraPosition(target: LatLng(48.856613, 2.352222), zoom: 15);
    }
  }
}
