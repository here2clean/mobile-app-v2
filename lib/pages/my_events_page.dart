import 'package:flutter/material.dart';
import 'package:here_to_clean_v2/controls/my_events_page.dart';
import 'package:here_to_clean_v2/model/volunteer.dart';

class MyEventsPage extends StatelessWidget {
  final String token;
  final Volunteer volunteer;


  MyEventsPage({this.token, this.volunteer});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Mes Evènements"),),
      body: MyEventsView(token: token , volunteer: volunteer ,),
    );
  }

}

