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
    return _AssociationDetailViewState(
        association: association, token: token, volunteer: volunteer);
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
  void initState() {
    // TODO: implement initState
      super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double availableWidth = MediaQuery.of(context).size.width - 160;
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
              flexibleSpace: FlexibleSpaceBar(
                  title: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: availableWidth,
                      ),
                      child: Padding(
                        child: Text(
                          association.name,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontFamily: 'RobotoSlab',
                          ),
                          overflow: TextOverflow.fade,
                        ),
                        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      )),
                  background: Image.network(
                    association.urlImage,
                    fit: BoxFit.cover,
                  ))
          )
        ],
      ),
      bottomSheet: Container(
        child: ButtonBar(
          children: <Widget>[TextField(),Switch()],
        ),
      )
    );
  }
}
