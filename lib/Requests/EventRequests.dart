import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:here_to_clean_v2/constants/h2c_api_routes.dart';
import 'package:here_to_clean_v2/httpClients/H2CHttpClient.dart';
import 'package:here_to_clean_v2/model/Event.dart';

class EventRequests {
  final H2CHttpClient httpClient;


  EventRequests(this.httpClient);


  Future<bool> signOutAnEvent(int eventId, int volunteerId) async {
    var queryParameters = {
      'event_id': eventId.toString(),
      'volunteer_id': volunteerId.toString()
    };

    Uri removeAVolunteerFromAnEvent = Uri.http(H2CApiRoutes.HereToClean,
        H2CApiRoutes.removeAVolunteerFromAnEvent, queryParameters);

    final response = await httpClient.post(removeAVolunteerFromAnEvent);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw (response.statusCode);
    }
  }

  Future<bool> signInAnEvent(int eventId, int volunteerId) async {
    var queryParameters = {
      'event_id': eventId.toString(),
      'volunteer_id': volunteerId.toString()
    };

    Uri addAVolunteerToAnEvent = Uri.http(H2CApiRoutes.HereToClean,
        H2CApiRoutes.addAVolunteerToAnEvent, queryParameters);

    // ignore: close_sinks
    final response = await httpClient.post(addAVolunteerToAnEvent);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw (response.statusCode);
    }
  }

  List<Event> _parseMyEvents(String responseBody) {
    log(responseBody);
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Event>((json) => Event.fromJson(json)).toList();
  }


}
