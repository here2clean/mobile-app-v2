import 'package:flutter/material.dart';
import 'package:here_to_clean_v2/controls/event_list_view.dart';
import 'package:here_to_clean_v2/controls/main_drawer.dart';
import 'package:here_to_clean_v2/controls/map_view.dart';
import 'package:here_to_clean_v2/model/volunteer.dart';

class MainPage extends StatefulWidget {
  final String token;
  final Volunteer volunteer;


  MainPage({this.token, this.volunteer});


  @override
  State<StatefulWidget> createState() {
    return _MainPageState(token: token, volunteer: volunteer);
  }
}

class _MainPageState extends State<MainPage>{

  final String token;
  final Volunteer volunteer;

  Map<String, String> _filters = {
    "filterByDate" : "false"
  };

  bool _isFiltered = false;

  _MainPageState({this.token, this.volunteer});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: MainDrawer(
          token: token,
          volunteer: volunteer,
        ),
        appBar: AppBar(
          title: Text("Here to Clean"),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.map),
                text: 'Carte',
              ),
              Tab(
                icon: Icon(Icons.list),
                text: 'Liste',
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MapView(
              token: token,
              volunteer: volunteer,
              filters: _filters,
            ),
            EventListView(
              token: token,
              volunteer: volunteer,
              filters: _filters,
            )
          ],
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomSheet: Container(
          color: Colors.green,
          child: ButtonBar(
            children: <Widget>[
              Text("Cacher les évênements passés"),
              Switch(
                value: _isFiltered,
                onChanged: (bool) {
                  setState(() {
                    _filters["filterByDate"] = bool.toString();
                    _isFiltered = bool;
                  });

                },
                activeColor: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }

}