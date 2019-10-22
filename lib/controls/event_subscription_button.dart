import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:here_to_clean_v2/constants/h2c_api_routes.dart';
import 'package:here_to_clean_v2/enums/VolunteerState.dart';
import 'package:here_to_clean_v2/httpClients/H2CHttpClient.dart';
import 'package:here_to_clean_v2/model/Event.dart';
import 'package:here_to_clean_v2/model/volunteer.dart';

class EventSubscriptionButton extends StatefulWidget {
  final Event event;
  final String token;
  final Volunteer volunteer;

  EventSubscriptionButton(this.token, this.event, this.volunteer);

  @override
  State<StatefulWidget> createState() {
    return _EventSubscriptionButtonState(
        this.event, this.token, this.volunteer);
  }
}

class _EventSubscriptionButtonState extends State<EventSubscriptionButton> {
  final Event event;
  final String token;
  final Volunteer volunteer;

  _EventSubscriptionButtonState(this.event, this.token, this.volunteer);

  Color _color = Colors.green;
  Text _text = Text("Evènement terminé");
  Icon _icon = Icon(Icons.refresh);
  VolunteerState _state = VolunteerState.unenrolled;


  void _setButtonColor(Event event) {
    log("Je passe dans _setButtonColor");
    setState(() {
      if (event == null || event.endDate.isBefore(DateTime.now())) {
        _color = Colors.grey;
      } else {
        _color = Colors.green;
      }
    });
  }

  void _setButtonText(VolunteerState state, Event event) {
    log("Je passe dans _setButtonText [$state]");

    setState(() {
      if(this.event.endDate.isBefore(DateTime.now())){
        _text = Text("Evènement terminé", style: TextStyle(color: Colors.white));
        return;
      }

      if (state != VolunteerState.enrolled) {
        _text = Text("S'inscrire", style: TextStyle(color: Colors.white));
      } else {
        _text = Text("Se désinscrire", style: TextStyle(color: Colors.white));
      }
    });
  }

  void _setButtonIcon(VolunteerState state, Event event) {
    log("Je passe dans __setButtonIcon [$state]");
    setState(() {
      if(this.event.endDate.isBefore(DateTime.now())){
        _icon = Icon(Icons.alarm_off, color: Colors.white);
        return;
      }
      if (state != VolunteerState.enrolled) {
        _icon = Icon(Icons.crop_square, color: Colors.white);
      } else {
        _icon = Icon(Icons.check_box, color: Colors.white);
      }
    });
  }

  static List<Event> parseMyEvents(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Event>((json) => Event.fromJson(json)).toList();
  }

  Future<void> getEventState(H2CHttpClient client) async {
    var queryParameters = {'email': volunteer.email};

    Uri getEventsOfAVolunteer = Uri.http(H2CApiRoutes.HereToClean,
        H2CApiRoutes.getEventsOfAVolunteer, queryParameters);

    final response = await client.get(getEventsOfAVolunteer);

    if (response.statusCode == 200) {
      List<Event> myEvents = parseMyEvents(response.body);
      if (myEvents.where((mEvent) => mEvent.id == event.id).length > 0) {
         setState(() {
          _state = VolunteerState.enrolled;
        });
      }
    } else {
      throw (response.statusCode);
    }
    log("getEventState [$_state]");
  }

  Future<void> setDisplay() async{
   await getEventState(H2CHttpClient(token: token));
    _setButtonColor(event);
    _setButtonIcon(_state, this.event);
    _setButtonText(_state, this.event);
  }

  Future<bool> signInAnEvent(H2CHttpClient client) async {
    var queryParameters = {
      'event_id': event.id.toString(),
      'volunteer_id': volunteer.id.toString()
    };

    Uri addAVolunteerToAnEvent = Uri.http(H2CApiRoutes.HereToClean,
        H2CApiRoutes.addAVolunteerToAnEvent, queryParameters);

    final response = await client.post(addAVolunteerToAnEvent);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw (response.statusCode);
    }
  }

  Future<bool> signOutAnEvent(H2CHttpClient client) async {
    var queryParameters = {
      'event_id': event.id.toString(),
      'volunteer_id': volunteer.id.toString()
    };

    Uri removeAVolunteerFromAnEvent = Uri.http(H2CApiRoutes.HereToClean,
        H2CApiRoutes.removeAVolunteerFromAnEvent, queryParameters);

    final response = await client.post(removeAVolunteerFromAnEvent);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw (response.statusCode);
    }
  }

  @override
  void initState() {
    log("Je passe dans initState [$_state] " );
    setDisplay();
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 250,
      child: GestureDetector(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: ([Colors.lightGreen, _color, Colors.lightGreen]),
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft)),
          child: Padding(
            child: Row(
              children: <Widget>[
                _icon,
                _text
              ],
            ),
            padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
          ),
        ),
        onTap: () => {
          setState(() {
            if (event.endDate.isBefore(DateTime.now())) {
              return;
            }
            if (_state == VolunteerState.enrolled) {
              log("Je passe ici enrolled");
              signOutAnEvent(H2CHttpClient(token: token));
              this._state = VolunteerState.unenrolled;
            } else {
              log("Je passe ici unenrolled");
              signInAnEvent(H2CHttpClient(token: token));
              this._state = VolunteerState.enrolled;
            }
            _setButtonColor(this.event);
            _setButtonIcon(this._state, this.event);
            _setButtonText(this._state, this.event);
          })
        },
      ),
    );
  }
}
