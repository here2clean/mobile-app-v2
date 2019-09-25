import 'package:here_to_clean_v2/model/volunteer.dart';

import 'Association.dart';

class Event{
  int id;
  String name;
  DateTime beginDate;
  DateTime endDate;
  String description;
  String location;
  String urlImage;

  List<Volunteer> volunteers;
  Association association;

  Event({this.id, this.name, this.beginDate, this.endDate, this.description, this.location, this.urlImage, this.volunteers, this.association});

  factory Event.fromJson(Map<String, dynamic> json){
    return Event(
      id: json["id"],
      name: json["name"],
      beginDate: DateTime.parse(json['beginDate']),
      endDate: DateTime.parse(json['endDate']),
      description: json["description"],
      location: json["location"],
      urlImage: json["urlImage"]
    );
  }
}