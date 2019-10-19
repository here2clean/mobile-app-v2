import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:here_to_clean_v2/constants/h2c_api_routes.dart';
import 'package:here_to_clean_v2/controls/unique_map_view.dart';
import 'package:here_to_clean_v2/enums/VolunteerState.dart';
import 'package:here_to_clean_v2/httpClients/H2CHttpClient.dart';
import 'package:here_to_clean_v2/model/Association.dart';
import 'package:here_to_clean_v2/model/Event.dart';
import 'package:here_to_clean_v2/model/volunteer.dart';
import 'package:intl/intl.dart';

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
  Association association;

  VolunteerState state = VolunteerState.unenrolled;

  Future<void> getEventState(H2CHttpClient client) async {
    var queryParameters = {'email': volunteer.email};

    Uri getEventsOfAVolunteer = Uri.http(H2CApiRoutes.HereToClean,
        H2CApiRoutes.getEventsOfAVolunteer, queryParameters);

    final response = await client.get(getEventsOfAVolunteer);

    if (response.statusCode == 200) {
      List<Event> myEvents = parseMyEvents(response.body);
      if (myEvents.where((mEvent) => mEvent.id == event.id).length > 0) {
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
    getEventState(H2CHttpClient(token: token));
    super.initState();
  }

  String formatDate(DateTime date) {
    return new DateFormat('dd-MM-yyyy ').format(date);
  }

  @override
  Widget build(BuildContext context) {
    double availableWidth = MediaQuery.of(context).size.width - 160;
    return Scaffold(
      body: CustomScrollView(slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          expandedHeight: 250.0,
          flexibleSpace: FlexibleSpaceBar(
              title: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: availableWidth,
                  ),
                  child: Padding(
                    child: Text(
                      event.name,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'Roboto',
                      ),
                      overflow: TextOverflow.fade,
                    ),
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  )),
              background: Image.network(
                event.urlImage,
                fit: BoxFit.cover,
              )),
        ),
        SliverFixedExtentList(
          itemExtent: 200.0,
          delegate: SliverChildListDelegate([
            Container(
              child: UniqueMapView(
                token: token,
                event: event,
              ),
              color: Colors.white,
            ),
            Container(
              padding: EdgeInsets.all(10),
              color: Colors.white,
              child: Text(
                event.description,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontFamily: 'RobotoSlab',
                    fontStyle: FontStyle.italic),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Text("Du : " +
                        formatDate(event.beginDate) +
                        '\n' +
                        "Au : " +
                        formatDate(event.endDate)),
                    color: Colors.transparent,
                  ),
                ),
                Container(
                  width: 200,
                  height: 250,
                  child: GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: ([
                                Colors.lightGreen,
                                Colors.green,
                                Colors.lightGreen
                              ]),
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft)),
                      child: Padding(
                        child: Row(
                          children: <Widget>[
                            Icon(
                              (state != VolunteerState.enrolled
                                  ? Icons.crop_square
                                  : Icons.check_box),
                              color: Colors.white,
                            ),
                            (state != VolunteerState.enrolled
                                ? Text(
                                    "S'inscrire",
                                    style: TextStyle(color: Colors.white),
                                  )
                                : Text("Se désinscrire",
                                    style: TextStyle(color: Colors.white)))
                          ],
                        ),
                        padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                      ),
                    ),
                    onTap: () => {
                      setState(() {
                        if (state == VolunteerState.enrolled) {
                          log("enrolled");
                          signOutAnEvent(H2CHttpClient(token: token));
                          state = VolunteerState.unenrolled;
                        } else {
                          log("unenrolled");
                          signInAnEvent(H2CHttpClient(token: token));
                          state = VolunteerState.enrolled;
                        }
                      })
                    },
                  ),
                ),
              ],
            ),
          ]),
        )
      ]),
    );
  }
}
