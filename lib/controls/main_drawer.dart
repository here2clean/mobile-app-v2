import 'package:flutter/material.dart';
import 'package:here_to_clean_v2/model/volunteer.dart';
import 'package:here_to_clean_v2/pages/associations_page.dart';

import 'package:here_to_clean_v2/pages/cgu_page.dart';
import 'package:here_to_clean_v2/pages/my_events_page.dart';

class MainDrawer extends StatefulWidget {
  final String token;
  final Volunteer volunteer;


  MainDrawer({this.token, this.volunteer});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MainDrawerState(token: token, volunteer: volunteer );
  }
}

class _MainDrawerState extends State<MainDrawer> {
  final String token;
  final Volunteer volunteer;


  _MainDrawerState({this.token, this.volunteer});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text("Here To Clean"),
            decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                    image: AssetImage('assets/logos/h2clogo.png'))),
          ),
          ListTile(
            title: Text("Mes évenements"),
            onTap: () => {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyEventsPage(token: token, volunteer: volunteer,)))
            },
          ),
          ListTile(
            title: Text("Les associations"),
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AssociationsPage(token: token,  volunteer: volunteer)))
            },
          ),
          ListTile(
            title: Text("Mon profil"),
            onTap: () => {},
          ),
          ListTile(
            title: Text("CGU"),
            onTap: () => {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => CGUPage()))
            },
          ),
        ],
      ),
    );
  }
}
