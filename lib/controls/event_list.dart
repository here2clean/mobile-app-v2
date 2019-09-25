import 'package:flutter/material.dart';
import 'package:here_to_clean_v2/model/Event.dart';

class EventList extends StatelessWidget {
  final List<Event> events;

  EventList({this.events});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemCount: events.length,
        itemBuilder: (context, index) { return
          Column(
            children: <Widget>[Card(
              child: Row(
                children: <Widget>[Image.network(events[index].urlImage,width: 150,), Text(events[index].name)],
              ),
            ),
            ],
          );



        }
    );
  }

}

