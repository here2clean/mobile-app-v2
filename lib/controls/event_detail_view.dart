import 'package:flutter/material.dart';
import 'package:here_to_clean_v2/constants/h2c_api_routes.dart';
import 'package:here_to_clean_v2/controls/unique_map_view.dart';
import 'package:here_to_clean_v2/enums/VolunteerState.dart';
import 'package:here_to_clean_v2/httpClients/H2CHttpClient.dart';
import 'package:here_to_clean_v2/model/Event.dart';

class EventDetailView extends StatefulWidget {
  final String token;
  final Event event;

  EventDetailView({this.token, this.event});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _EventDetailViewState(token: token, event: event);
  }
}

class _EventDetailViewState extends State<EventDetailView> {
  final String token;
  final Event event;
  VolunteerState state = VolunteerState.unenrolled;

  Future<bool> signIn(H2CHttpClient client) async {
    var queryParameters = {
      'association_id': event.id.toString(),
      'volunteer_id': event.id.toString(),
    };

    Uri addAVolunteerToAnEvent = Uri.http(H2CApiRoutes.HereToClean,
        H2CApiRoutes.addAVolunteerToAnEvent, queryParameters);
    final response = await client.post(H2CApiRoutes.getAllAssociations);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  _EventDetailViewState({this.token, this.event});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomCenter,
              colors: [Colors.green, Colors.white])),
      child: Padding(
        child: Column(children: <Widget>[
          Row(children: [
            Card(
              child: Text(event.description),
            )
          ]),
          Expanded(child: Container()),
          Container(),
          Stack(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      width: 200,
                      height: 300,
                      child: UniqueMapView(token: token, event: event),
                    ),
                  )
                ],
              ),
              Positioned(
                right: 0,
                child: FloatingActionButton.extended(
                  label: (state != VolunteerState.enrolled
                      ? Text("S'incsrire")
                      : Text("Se désinscrire")),
                  onPressed: () {
                    setState(() {
                      if (state == VolunteerState.enrolled) {
                        state = VolunteerState.unenrolled;
                      } else {
                        state = VolunteerState.enrolled;
                      }
                    });
                  },
                  tooltip: (state != VolunteerState.enrolled
                      ? "S'incsrire"
                      : "Se desinscrire"),
                  icon: Icon((state != VolunteerState.enrolled
                      ? Icons.crop_square
                      : Icons.check_box)),
                  backgroundColor: (state != VolunteerState.enrolled
                      ? Colors.green
                      : Colors.green),
                ),
              )
            ],
          )
        ]),
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      ),
    );
  }
}
