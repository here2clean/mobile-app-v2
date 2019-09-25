import 'package:flutter/material.dart';

import 'package:here_to_clean_v2/pages/cgu_page.dart';

class MainDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MainDrawerState();
  }
}

class _MainDrawerState extends State<MainDrawer> {
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
            onTap: () => {},
          ),
          ListTile(
            title: Text("Mon profil"),
            onTap: () => {},
          ),
          ListTile(
            title: Text("CGU"),
            onTap: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CGUPage()))
            },
          ),

        ],
      ),
    );
  }
}
