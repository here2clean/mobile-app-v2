import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:here_to_clean_v2/model/volunteer.dart';

import 'Association.dart';

class Association {
  int id;
  int numberRna;
  String name;
  String description;
  String location;
  String urlImage;

  Association(
      {this.id,
      this.numberRna,
      this.name,
      this.description,
      this.location,
      this.urlImage});

  factory Association.fromJson(Map<String, dynamic> json) {
    return Association(
      id: json["id"],
      name: json["name"],
      numberRna: json['numberRna'],
      description: json["description"],
      location: json["location"],
      urlImage: json["urlImage"],
    );
  }

  @override
  String toString() {
    return 'Association{id: $id, numberRna: $numberRna, name: $name, description: $description, location: $location, urlImage: $urlImage}';
  }


}
