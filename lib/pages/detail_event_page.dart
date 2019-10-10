import 'package:flutter/material.dart';
import 'package:here_to_clean_v2/controls/association_detail_view.dart';
import 'package:here_to_clean_v2/controls/event_detail_view.dart';
import 'package:here_to_clean_v2/model/Association.dart';
import 'package:here_to_clean_v2/model/Event.dart';
import 'package:here_to_clean_v2/model/volunteer.dart';

class DetailEventPage extends StatefulWidget {
  final String token;
  final Event event;
  final Volunteer volunteer;

  DetailEventPage({this.token, this.event, this.volunteer});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DetailEventPageState(
        event: event, token: token, volunteer: volunteer);
  }
}

class _DetailEventPageState extends State<DetailEventPage> {
  final Event event;
  final String token;
  final Volunteer volunteer;

  _DetailEventPageState({this.event, this.token, this.volunteer});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return EventDetailView(
      event: event,
      token: token,
      volunteer: volunteer,
    );
  }
}
