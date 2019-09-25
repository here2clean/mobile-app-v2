import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:here_to_clean_v2/controls/event_list.dart';
import 'package:here_to_clean_v2/httpClients/H2CHttpClient.dart';
import 'package:here_to_clean_v2/model/Event.dart';
import 'package:http/http.dart' as http;




class EventListView extends StatefulWidget {
  final String token;

  EventListView({this.token});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _EventListViewState(token: token);
  }
}

class _EventListViewState extends State<EventListView> {
  final String token;

  _EventListViewState({this.token});

  Future<List<Event>> fetchEvents(H2CHttpClient client) async {
    final response =
        await client.get('http://heretoclean.cambar.re/api/event/all');

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
      body: Padding(
        child: FutureBuilder<List<Event>>(
          future: fetchEvents(H2CHttpClient(token: token)),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return EventList(events: snapshot.data );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      ),
    );
    ;
  }
}
