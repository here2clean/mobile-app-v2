import 'package:flutter/material.dart';
import 'package:here_to_clean_v2/model/Event.dart';
import 'package:here_to_clean_v2/pages/detail_event_page.dart';

class EventList extends StatelessWidget {
  final List<Event> events;
  final String token;


  EventList({this.events, this.token});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: events.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              GestureDetector(
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailEventPage(
                            event: events[index], token: token,)))

                },
                child: Card(
                  child: Row(
                    children: <Widget>[
                      (events[index].urlImage != null
                          ? Image.network(events[index].urlImage, width: 150)
                          : Container(
                        decoration: BoxDecoration(color: Colors.green),
                        child: Image.asset('assets/logos/h2clogo.png'),
                        width: 150,
                      )),
                      Text(events[index].name)
                    ],
                  ),
                ),
              )
              ,
            ],
          );
        });
  }
}
