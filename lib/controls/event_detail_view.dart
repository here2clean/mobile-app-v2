import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:here_to_clean_v2/controls/event_subscription_button.dart';
import 'package:here_to_clean_v2/controls/unique_map_view.dart';
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
    return _EventDetailViewState(token: token, event: event, volunteer: volunteer);
  }
}

class _EventDetailViewState extends State<EventDetailView> {
  final String token;
  final Event event;
  final Volunteer volunteer;
  Association association;

  _EventDetailViewState({this.token, this.event, this.volunteer});

  @override
  void initState() {
    super.initState();
  }

  String formatDate(DateTime date) {
    return new DateFormat('dd-MM-yyyy').format(date);
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
                EventSubscriptionButton(this.token, this.event, this.volunteer)
              ],
            ),
          ]),
        )
      ]),
    );
  }
}
