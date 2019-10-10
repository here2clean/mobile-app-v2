import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:here_to_clean_v2/constants/h2c_api_routes.dart';
import 'package:here_to_clean_v2/httpClients/H2CHttpClient.dart';
import 'package:here_to_clean_v2/httpClients/H2CTokenLessHttpClient.dart';
import 'package:here_to_clean_v2/model/volunteer.dart';

class SignUpForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignUpFormState();
  }
}

class _SignUpFormState extends State<SignUpForm> {
  String _email;
  String _password;
  String _repeatPassword;
  String _name;
  String _surname;
  String _birthDate;
  String _city;
  String _cityCode;
  String _address;
  final TextEditingController _pwdController = new TextEditingController();

  final GlobalKey<FormState> _SignUpFormGlobalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Card(
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
                padding: EdgeInsets.all(15),
                child: Form(
                  key: _SignUpFormGlobalKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        validator: (input) {
                          return _emailValidator(input);
                        },
                        onSaved: (input) => _email = input,
                        decoration: InputDecoration(
                          icon: Icon(Icons.mail),
                          labelText: "Mail",
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      TextFormField(
                        controller: _pwdController,
                        onSaved: (input) => _password = input,
                        decoration: InputDecoration(
                            icon: Icon(Icons.lock), labelText: "Mot de passe"),
                        obscureText: true,
                        validator: (input) {
                          return _notEmptyValidator(input);
                        },
                      ),
                      TextFormField(
                        onSaved: (input) => _repeatPassword = input,
                        decoration: InputDecoration(
                            icon: Icon(Icons.lock),
                            labelText: "Repétez le mot de passe"),
                        obscureText: true,
                        validator: (input) {
                          print(_pwdController.value.text);
                          if (input != _pwdController.value.text) {
                            return "Les mots de passe ne correspondent pas !";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        onSaved: (input) => _name = input,
                        decoration: InputDecoration(
                            icon: Icon(Icons.face), labelText: "Prénom"),
                        validator: (input) {
                          return _notEmptyValidator(input);
                        },
                      ),
                      TextFormField(
                        onSaved: (input) => _surname = input,
                        decoration: InputDecoration(
                            icon: Icon(Icons.face), labelText: "Nom"),
                        validator: (input) {
                          return _notEmptyValidator(input);
                        },
                      ),
                      TextFormField(
                        onSaved: (input) => _birthDate = input.toString(),
                        decoration: InputDecoration(
                            icon: Icon(Icons.cake),
                            labelText: "Date de naissance"),
                        keyboardType: TextInputType.datetime,
                        validator: (input) {
                          return _bdateValidator(input);
                        },
                      ),
                      TextFormField(
                        onSaved: (input) => _address = input,
                        decoration: InputDecoration(
                            icon: Icon(Icons.place), labelText: "Adresse"),
                        keyboardType: TextInputType.text,
                        validator: (input) {
                          return _notEmptyValidator(input);
                        },
                      ),
                      TextFormField(
                        onSaved: (input) => _city = input,
                        decoration: InputDecoration(
                            icon: Icon(Icons.place), labelText: "Ville"),
                        keyboardType: TextInputType.datetime,
                        validator: (input) {
                          return _notEmptyValidator(input);
                        },
                      ),
                      TextFormField(
                        onSaved: (input) => _cityCode = input,
                        decoration: InputDecoration(
                            icon: Icon(Icons.place), labelText: "Code Postal"),
                        keyboardType: TextInputType.number,
                        validator: (input) {
                          return _zipValidator(input);
                        },
                      ),
                      RaisedButton(
                        child: Text('Rejoins nous !'),
                        onPressed: () => {_signUp(H2CTokenLessHttpClient())},
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        color: Theme.of(context).primaryColor,
                      )
                    ],
                  ),
                ))));
  }

  Future<void> _signUp(H2CTokenLessHttpClient client) async {
    final FormState formState = _SignUpFormGlobalKey.currentState;
    if(formState.validate()){
      formState.save();
      final Volunteer v = new Volunteer(
          address: _address,
          id: 0,
          lastName: _name,
          firstName: _surname,
          city: _city,
          cityCode: _cityCode,
          birthday: DateTime.now() ,// DateTime.parse(formatDate(_birthDate)),
          email: _email,
          password: _password);


      Map<String, String> body =  v.toJson();
      log(json.encode(body));

      Uri getAllEventsByAssociation = Uri.http(
          H2CApiRoutes.HereToClean, H2CApiRoutes.signUp);

      final response = await client.post(getAllEventsByAssociation, body:json.encode(body)  );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showToast(context);
      } else {
        throw new Exception(response.body);
      }
    }


  }

  String _emailValidator(input) {
    final String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
    final RegExp regExp = new RegExp(pattern);

    if (!regExp.hasMatch(input)) {
      return "Email invalide !";
    }
    return null;
  }

  String _zipValidator(input) {
    final String pattern = r"^(([0-8][0-9])|(9[0-8])|(2[ab]))[0-9]{3}$";
    final RegExp regExp = new RegExp(pattern);

    if (!regExp.hasMatch(input)) {
      return "Code postal invalide !";
    }
    return null;
  }

  String _bdateValidator(input) {
    final String pattern =
        r"^(0?[1-9]|[12][0-9]|3[01])[\/](0?[1-9]|1[012])[\/\-]\d{4}$";
    final RegExp regExp = new RegExp(pattern);

    if (!regExp.hasMatch(input)) {
      return "Date de naissance invalide !";
    }
    return null;
  }

  String _notEmptyValidator(String input) {
    if (input.isEmpty) {
      return "Ce champ est obligatoire";
    }
    return null;
  }

  void _showToast(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text("Enregisté !"),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  String formatDate(String date) {
    log(date);
    var items = date.split("/");
    log("" + items[2].toString() + items[1].toString() + items[0].toString());
    return "" + items[2].toString() + items[1].toString() + items[0].toString();
  }
}
