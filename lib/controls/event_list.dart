import 'package:flutter/material.dart';
import 'package:here_to_clean_v2/model/Event.dart';
import 'package:here_to_clean_v2/model/volunteer.dart';
import 'package:here_to_clean_v2/pages/detail_event_page.dart';

class EventList extends StatelessWidget {
  final List<Event> events;
  final String token;
  final Volunteer volunteer;

  EventList({this.events, this.token, this.volunteer});

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
                                event: events[index],
                                token: token,
                                volunteer: volunteer,
                              )))
                },
                child: Card(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        (events[index].urlImage != null
                            ? Image.network(
                          events[index].urlImage,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        )
                            : Container(
                          decoration: BoxDecoration(color: Colors.green),
                          child: Image.asset('assets/logos/h2clogo.png'),
                          width: 150,
                          height: 150,
                        )),
                        Container(
                          child: Expanded(
                            child: Center(
                              child: Text(
                                events[index].name,
                                softWrap: true,
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ),
              ),
            ],
          );
        });
  }
}
