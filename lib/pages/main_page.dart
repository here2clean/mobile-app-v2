import 'package:flutter/material.dart';
import 'package:here_to_clean_v2/controls/event_list_view.dart';
import 'package:here_to_clean_v2/controls/main_drawer.dart';
import 'package:here_to_clean_v2/controls/map_view.dart';

class MainPage extends StatelessWidget {
  final String token;

  MainPage({this.token});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          drawer: MainDrawer(
            token: token,
          ),
          appBar: AppBar(
            title: Text('Here to Clean'),
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
            children: [MapView(token: token), EventListView(token: token)],
            physics: NeverScrollableScrollPhysics(),
          )),
    );
  }
}
