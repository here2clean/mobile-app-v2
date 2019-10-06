import 'dart:convert';
import 'dart:core' as prefix0;
import 'dart:core';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:here_to_clean_v2/constants/h2c_api_routes.dart';
import 'package:here_to_clean_v2/httpClients/H2CHttpClient.dart';
import 'package:here_to_clean_v2/model/volunteer.dart';
import 'package:here_to_clean_v2/pages/main_page.dart';

class SignInForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignInFormState();
  }
}

class _SignInFormState extends State<SignInForm> {
  String _email;
  String _password;
  final GlobalKey<FormState> _SignInFormGlobalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
            padding: EdgeInsets.all(15),
            child: Form(
              key: _SignInFormGlobalKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    validator: (input) {
                      if (!input.contains('@')) {
                        return 'Format de l\'adresse mail incorrect';
                      }
                    },
                    onSaved: (input) => _email = input,
                    decoration: InputDecoration(
                      icon: Icon(Icons.mail),
                      labelText: "Mail",
                    ),
                  ),
                  TextFormField(
                    onSaved: (input) => _password = input,
                    decoration: InputDecoration(
                        icon: Icon(Icons.lock), labelText: "Password"),
                    obscureText: true,
                  ),
                  RaisedButton(
                    child: Text('Sign In'),
                    onPressed: _signIn,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    color: Theme.of(context).primaryColor,
                  )
                ],
              ),
            )));
  }
  Future<Volunteer> _getUserByMail(H2CHttpClient client, String mail) async{
    var queryParameters = {
      'email': mail,
    };

    Uri addAVolunteerToAnEvent = Uri.http(H2CApiRoutes.HereToClean,
        H2CApiRoutes.getVolunteerByMail, queryParameters);
    var response = await client.get(addAVolunteerToAnEvent);
    if (response.statusCode == 200){
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return Volunteer.fromJson(parsed);
    }
  }

  Future<void> _signIn() async {
    final FormState formState = _SignInFormGlobalKey.currentState;
    if (formState.validate()) {
      formState.save();
      print("_password" + _password);
      print("_email" + _email);
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _email.trim(), password: _password.trim());

        var user = await FirebaseAuth.instance.currentUser();
        var tokenId = await user.getIdToken();
        var volunteer = await _getUserByMail(H2CHttpClient(token: tokenId.token), user.email);

        log(volunteer.toString());

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MainPage(token: tokenId.token,volunteer: volunteer,)));
      } catch (e) {
        print(e.message);
      }
    }
  }
}
