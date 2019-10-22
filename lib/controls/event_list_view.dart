import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:here_to_clean_v2/controls/event_list.dart';
import 'package:here_to_clean_v2/httpClients/H2CHttpClient.dart';
import 'package:here_to_clean_v2/model/Event.dart';
import 'package:here_to_clean_v2/constants/h2c_api_routes.dart';
import 'package:here_to_clean_v2/model/volunteer.dart';

class EventListView extends StatefulWidget {
  final String token;
  final Volunteer volunteer;
  final Map<String, String> filters;

  EventListView({this.token, this.volunteer, this.filters});

  @override
  State<StatefulWidget> createState() {
    return _EventListViewState(
        token: token, volunteer: volunteer, filters: filters);
  }
}

class _EventListViewState extends State<EventListView> {
  final String token;
  final Volunteer volunteer;
  final Map<String, String> filters;

  _EventListViewState({this.token, this.volunteer, this.filters});

  Future<List<Event>> fetchEvents(H2CHttpClient client) async {
    final response = await client.get(H2CApiRoutes.getAllEvents);

    if (response.statusCode == 200) {
      return parseEvents(response.body, filters);
    } else {
      throw new Exception(response.statusCode);
    }
  }

  static List<Event> parseEvents(
      String responseBody, Map<String, String> filters) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    List<Event> events =
        parsed.map<Event>((json) => Event.fromJson(json)).toList();
    events = events
        .where((e) => (e.endDate.isAfter(DateTime.now()) ||
            filters["filterByDate"] == "false"))
        .toList();
    return events;
  }

  @override
  Widget build(BuildContext context) {
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
            if (snapshot.hasError) {
              throw snapshot.error;
            }
            if (snapshot.hasData) {
              return Padding(
                child: EventList(
                  events: snapshot.data,
                  token: token,
                  volunteer: volunteer,
                ),
                padding: EdgeInsets.fromLTRB(0, 0, 0, 90),
              );
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
