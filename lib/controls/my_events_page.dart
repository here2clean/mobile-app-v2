import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:here_to_clean_v2/constants/h2c_api_routes.dart';
import 'package:here_to_clean_v2/controls/event_list.dart';
import 'package:here_to_clean_v2/httpClients/H2CHttpClient.dart';
import 'package:here_to_clean_v2/model/Event.dart';
import 'package:here_to_clean_v2/model/volunteer.dart';

class MyEventsView extends StatefulWidget {
  final String token;
  final Volunteer volunteer;


  MyEventsView({this.token, this.volunteer});

  @override
  State<StatefulWidget> createState() {
    return _MyEventsViewState(token: token, volunteer: volunteer);
  }
}

class _MyEventsViewState extends State<MyEventsView> {

  final String token;
  final Volunteer volunteer;


  _MyEventsViewState({this.token, this.volunteer});

  Future<List<Event>> fetchMyEvents(H2CHttpClient client) async {

    var queryParameters = {
      'email': volunteer.email
    };

    Uri getEventsOfAVolunteer = Uri.http(H2CApiRoutes.HereToClean,
        H2CApiRoutes.getEventsOfAVolunteer, queryParameters);

    final response = await client.get(getEventsOfAVolunteer);

    if (response.statusCode == 200) {
      return compute(parseMyEvents, response.body);
    } else {
      throw new Exception(response.statusCode);
    }
  }

  static List<Event> parseMyEvents(String responseBody) {
    log(responseBody);
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
              future: fetchMyEvents(H2CHttpClient(token: token)),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return EventList(events: snapshot.data, token: token, volunteer: volunteer,);
                }
                if(snapshot.hasError){
                  throw snapshot.error;
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          ),
        ));
  }
}
