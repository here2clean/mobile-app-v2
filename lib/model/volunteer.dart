class Volunteer {
  final double id;
  final String firstname;
  final String surname;
  final String address;
  final String city;
  final String zipCode;

  Volunteer(
      {this.id,
      this.firstname,
      this.surname,
      this.address,
      this.city,
      this.zipCode});

  factory Volunteer.fromJson(Map<String, dynamic> json) {
    return Volunteer(
      id: json["id"],
      firstname: json["name"],
      surname: json['beginDate'],
      address: json['endDate'],
      city: json["description"],
      zipCode: json["location"],
    );
  }

  @override
  String toString() {
    return 'Volunteer{id: $id, firstname: $firstname, surname: $surname, address: $address, city: $city, zipCode: $zipCode}';
  }


}
