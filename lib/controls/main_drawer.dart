import 'package:flutter/material.dart';
import 'package:here_to_clean_v2/controls/association_list_view.dart';
import 'package:here_to_clean_v2/pages/associations_page.dart';

import 'package:here_to_clean_v2/pages/cgu_page.dart';

class MainDrawer extends StatefulWidget {
  final String token;

  MainDrawer({this.token});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MainDrawerState(token: token);
  }
}

class _MainDrawerState extends State<MainDrawer> {
  final String token;

  _MainDrawerState({this.token});

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
            title: Text("Les associations"),
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AssociationsPage(token: token)))
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
