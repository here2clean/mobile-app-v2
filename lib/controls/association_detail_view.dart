import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:here_to_clean_v2/constants/h2c_api_routes.dart';
import 'package:here_to_clean_v2/controls/event_list.dart';
import 'package:here_to_clean_v2/httpClients/H2CHttpClient.dart';
import 'package:here_to_clean_v2/model/Association.dart';
import 'package:here_to_clean_v2/model/Event.dart';
import 'package:here_to_clean_v2/model/volunteer.dart';
import 'package:url_launcher/url_launcher.dart';

class AssociationDetailView extends StatefulWidget {
  final Association association;
  final String token;
  final Volunteer volunteer;

  AssociationDetailView({this.association, this.token, this.volunteer});

  @override
  State<StatefulWidget> createState() {
    return _AssociationDetailViewState(association: association, token: token, volunteer: volunteer);
  }
}

class _AssociationDetailViewState extends State<AssociationDetailView> {
  final Association association;
  final String token;
  final Volunteer volunteer;

  _AssociationDetailViewState({this.volunteer, this.association, this.token});

  Future<List<Event>> fetchEvents(H2CHttpClient client) async {
    var queryParameters = {
      'association_id': association.id.toString(),
    };

    Uri getAllEventsByAssociation = Uri.http(H2CApiRoutes.HereToClean,
        H2CApiRoutes.getAllEventsByAssociation, queryParameters);

    final response = await client.get(getAllEventsByAssociation);

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

  _launchURL() async {
    String url = Uri.http("51.83.32.228:3000", "/shop/1").toString();
    if (await canLaunch(url)) {
      await launch(url, headers: {"Authorization": "Bearer " + token});
    } else {
      throw 'Could not launch $url';
    }
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomCenter,
              colors: [Colors.green, Colors.white])),
      child: Padding(
        child: Column(children: <Widget>[
          Row(
            children: <Widget>[Text(association.description)],
          ),
          Expanded(child: Container()),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  width: 200,
                  height: 500,
                  child: FutureBuilder<List<Event>>(
                    future: fetchEvents(H2CHttpClient(token: token)),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return EventList(events: snapshot.data, token: token, volunteer: volunteer,);
                      }
                      if (snapshot.hasError) {
                        throw snapshot.error;
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              )
            ],
          ),
          ButtonBar(
            children: <Widget>[
              RaisedButton(
                child: Icon(Icons.shopping_cart),
                onPressed: () => {_launchURL()},
              )
            ],
          )
        ]),
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      ),
    );
  }
}
