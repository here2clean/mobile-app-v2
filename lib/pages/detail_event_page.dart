import 'package:flutter/material.dart';
import 'package:here_to_clean_v2/controls/association_detail_view.dart';
import 'package:here_to_clean_v2/controls/event_detail_view.dart';
import 'package:here_to_clean_v2/model/Association.dart';
import 'package:here_to_clean_v2/model/Event.dart';

class DetailEventPage extends StatefulWidget {
  final String token;
  final Event event;

  DetailEventPage({this.token, this.event});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DetailEventPageState(event: event, token: token);
  }
}

class _DetailEventPageState extends State<DetailEventPage> {
  final Event event;
  final String token;

  _DetailEventPageState({this.event, this.token});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(event.name),
      ),
      body: EventDetailView(
        event: event,
        token: token,
      ),
    );
  }
}