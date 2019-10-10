class Volunteer {
  final int id;
  final String firstName;
  final String lastName;
  final String address;
  final String city;
  final String cityCode;
  final String email;
  final String password;
  final DateTime birthday;

  Volunteer(
      {this.id,
      this.firstName,
      this.lastName,
      this.address,
      this.city,
      this.cityCode,
      this.email,
      this.password,
      this.birthday});

  factory Volunteer.fromJson(Map<String, dynamic> json) {
    return Volunteer(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json['lastName'],
        address: json['address'],
        city: json["city"],
        cityCode: json["cityCode"].toString(),
        email: json["email"],
        birthday: DateTime.parse(json["birthday"]));
  }

  Map<String, String> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'address': address,
        'city': city,
        'cityCode': cityCode,
        'birthday': birthday.day.toString()+"/"+birthday.month.toString()+"/"+birthday.year.toString(),
        'email': email,
        'password' : password
      };

  @override
  String toString() {
    return 'Volunteer{id: $id, firstName: $firstName, lastName: $lastName, address: $address, city: $city, cityCode: $cityCode, email: $email, password: $password, birthday: $birthday}';
  }
}
