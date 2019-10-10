import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:here_to_clean_v2/constants/h2c_api_routes.dart';
import 'package:here_to_clean_v2/controls/unique_map_view.dart';
import 'package:here_to_clean_v2/enums/VolunteerState.dart';
import 'package:here_to_clean_v2/httpClients/H2CHttpClient.dart';
import 'package:here_to_clean_v2/model/Event.dart';
import 'package:here_to_clean_v2/model/volunteer.dart';

class EventDetailView extends StatefulWidget {
  final String token;
  final Event event;
  final Volunteer volunteer;

  EventDetailView({this.token, this.event, this.volunteer});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _EventDetailViewState(
        token: token, event: event, volunteer: volunteer);
  }
}

class _EventDetailViewState extends State<EventDetailView> {
  final String token;
  final Event event;
  final Volunteer volunteer;

  VolunteerState state = VolunteerState.unenrolled;

  Future<void> GetEventState(H2CHttpClient client) async {
    var queryParameters = {'email': volunteer.email};

    Uri getEventsOfAVolunteer = Uri.http(H2CApiRoutes.HereToClean,
        H2CApiRoutes.getEventsOfAVolunteer, queryParameters);

    final response = await client.get(getEventsOfAVolunteer);

    if (response.statusCode == 200) {
      List<Event> myEvents = parseMyEvents(response.body);
      if (myEvents.map((mEvent) => mEvent.id == event.id).length > 0) {
        setState(() {
          state = VolunteerState.enrolled;
        });
      }
    } else {
      throw (response.statusCode);
    }
  }

  static List<Event> parseMyEvents(String responseBody) {
    log(responseBody);
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Event>((json) => Event.fromJson(json)).toList();
  }

  Future<bool> signInAnEvent(H2CHttpClient client) async {
    var queryParameters = {
      'event_id': event.id.toString(),
      'volunteer_id': volunteer.id.toString()
    };

    Uri addAVolunteerToAnEvent = Uri.http(H2CApiRoutes.HereToClean,
        H2CApiRoutes.addAVolunteerToAnEvent, queryParameters);

    final response = await client.post(addAVolunteerToAnEvent);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw (response.statusCode);
    }
  }

  Future<bool> signOutAnEvent(H2CHttpClient client) async {
    var queryParameters = {
      'event_id': event.id.toString(),
      'volunteer_id': volunteer.id.toString()
    };

    Uri removeAVolunteerFromAnEvent = Uri.http(H2CApiRoutes.HereToClean,
        H2CApiRoutes.removeAVolunteerFromAnEvent, queryParameters);

    final response = await client.post(removeAVolunteerFromAnEvent);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw (response.statusCode);
    }
  }

  _EventDetailViewState({this.token, this.event, this.volunteer});

  @override
  void initState() {
    GetEventState(H2CHttpClient(token: token));
    super.initState();
  }

  String formatDate(DateTime date) {
    return date.day.toString() +
        "/" +
        date.month.toString() +
        "/" +
        date.year.toString();
  }

  @override
  Widget build(BuildContext context) {
    AppBar _appBar = AppBar(
      title: Text(event.name),
    );

    // TODO: implement build
    return Scaffold(
        appBar: _appBar,
        body: Column(
          children: <Widget>[
            Container(
              color: Colors.green,
              height: (MediaQuery.of(context).size.height -
                          _appBar.preferredSize.height) /
                      2 -
                  10 -
                  60,
              width: _appBar.preferredSize.width - 14,
              child: Card(
                child: Text(event.description),
              ),
            ),
            Container(
              color: Colors.green,
              height: 60,
              width: _appBar.preferredSize.width - 10,
              child: Card(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      width: 220,
                      height: 50,
                      child: Text(formatDate(event.beginDate)),
                    ),
                    (event.endDate.millisecondsSinceEpoch <
                            DateTime.now().millisecondsSinceEpoch
                        ? Container()
                        : Container(
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  height: 50,
                                  width: 50,
                                ),
                                Positioned(
                                  child: FloatingActionButton.extended(
                                    label: (state != VolunteerState.enrolled
                                        ? Text("S'incsrire")
                                        : Text("Se désinscrire")),
                                    onPressed: () {
                                      setState(() {
                                        if (state == VolunteerState.enrolled) {
                                          signOutAnEvent(
                                              H2CHttpClient(token: token));
                                          state = VolunteerState.unenrolled;
                                        } else {
                                          signInAnEvent(
                                              H2CHttpClient(token: token));
                                          state = VolunteerState.enrolled;
                                        }
                                      });
                                    },
                                    tooltip: (state != VolunteerState.enrolled
                                        ? "S'incsrire"
                                        : "Se desinscrire"),
                                    icon: Icon((state != VolunteerState.enrolled
                                        ? Icons.crop_square
                                        : Icons.check_box)),
                                    backgroundColor:
                                        (state != VolunteerState.enrolled
                                            ? Colors.green
                                            : Colors.green),
                                  ),
                                )
                              ],
                            ),
                          ))
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.green,
              height: (MediaQuery.of(context).size.height -
                          _appBar.preferredSize.height) /
                      2 -
                  14,
              width: _appBar.preferredSize.width - 10,
              child: Card(
                  child: Container(
                      child: Stack(
                children: <Widget>[
                  Container(
                    child: UniqueMapView(token: token, event: event),
                  ),
                ],
              ))),
            ),
          ],
        ));
  }
}
