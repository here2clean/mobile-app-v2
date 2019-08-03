import 'package:flutter/material.dart';

class SignUpForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignUpFormState();
  }
}

class _SignUpFormState extends State<SignUpForm> {
  String _email;
  String _password;
  final GlobalKey<FormState> _SignUpFormGlobalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
          padding: EdgeInsets.all(15),
            child: Form(
      key: _SignUpFormGlobalKey,
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
            decoration:
                InputDecoration(icon: Icon(Icons.lock), labelText: "Password"),
            obscureText: true,
          )
        ],
      ),
    )));
  }
}
