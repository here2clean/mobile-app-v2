import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:here_to_clean_v2/controls/event_list.dart';
import 'package:here_to_clean_v2/httpClients/H2CHttpClient.dart';
import 'package:here_to_clean_v2/model/Event.dart';
import 'package:here_to_clean_v2/constants/h2c_api_routes.dart';
import 'package:here_to_clean_v2/model/volunteer.dart';

class EventListView extends StatefulWidget {
  final String token;
  final Volunteer volunteer;

  EventListView({this.token, this.volunteer});

  @override
  State<StatefulWidget> createState() {

    return _EventListViewState(token: token, volunteer: volunteer);
  }
}

class _EventListViewState extends State<EventListView> {
  final String token;
  final Volunteer volunteer;

  _EventListViewState({this.token, this.volunteer});

  Future<List<Event>> fetchEvents(H2CHttpClient client) async {
    final response = await client.get(H2CApiRoutes.getAllEvents);

    if (response.statusCode == 200) {
      return compute(parseEvents, response.body);
    } else {
      throw new Exception(response.statusCode);
    }
  }

  static List<Event> parseEvents(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Event>((json) => Event.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomCenter,
              colors: [Colors.green, Colors.white])),
      child: Padding(
        child: FutureBuilder<List<Event>>(
          future: fetchEvents(H2CHttpClient(token: token)),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return EventList(events: snapshot.data, token: token, volunteer: volunteer,);
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      ),
    ));
    ;
  }
}
