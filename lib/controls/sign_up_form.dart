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
  String _repeatPassword;
  String _name;
  String _surname;
  String _birthDate;
  String _city;
  String _cityCode;
  String _address;

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
                        validator: (input){ return emailValidator(input);},
                        onSaved: (input) => _email = input,
                        decoration: InputDecoration(
                          icon: Icon(Icons.mail),
                          labelText: "Mail",
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      TextFormField(
                        onSaved: (input) => _password = input,
                        decoration: InputDecoration(
                            icon: Icon(Icons.lock), labelText: "Password"),
                        obscureText: true,
                      ),
                      TextFormField(
                        onSaved: (input) => _repeatPassword = input,
                        decoration: InputDecoration(
                            icon: Icon(Icons.lock),
                            labelText: "Repeat Password"),
                        obscureText: true,
                        validator: (input) {
                          if (input != _password) {
                            return "Les mots de passe ne correspondent pas !";
                          }
                        },
                      ),
                      TextFormField(
                        onSaved: (input) => _name = input,
                        decoration: InputDecoration(
                            icon: Icon(Icons.face), labelText: "Name"),
                        validator: (input) {
                          if (input.isEmpty) {
                            return "Ce champ ne doit pas être vide !";
                          }
                        },
                      ),
                      TextFormField(
                        onSaved: (input) => _surname = input,
                        decoration: InputDecoration(
                            icon: Icon(Icons.face), labelText: "Surname"),
                      ),
                      TextFormField(
                        onSaved: (input) => _birthDate = input,
                        decoration: InputDecoration(
                            icon: Icon(Icons.cake), labelText: "Birthdate"),
                        keyboardType: TextInputType.datetime,
                      ),
                      TextFormField(
                        onSaved: (input) => _address = input,
                        decoration: InputDecoration(
                            icon: Icon(Icons.place), labelText: "Address"),
                        keyboardType: TextInputType.text,
                        validator: (input) {
                          if (input.isEmpty) {
                            return "Ce champ ne doit pas être vide !";
                          }
                        },
                      ),
                      TextFormField(
                        onSaved: (input) => _city = input,
                        decoration: InputDecoration(
                            icon: Icon(Icons.place), labelText: "City"),
                        keyboardType: TextInputType.datetime,
                      ),
                      TextFormField(
                        onSaved: (input) => _cityCode = input,
                        decoration: InputDecoration(
                            icon: Icon(Icons.place), labelText: "City Code"),
                        keyboardType: TextInputType.number,
                        validator: (input) {
                          if (input.isEmpty) {
                            return "Ce champ ne doit pas être vide !";
                          }
                        },
                      ),
                      RaisedButton(
                        child: Text('Join us !'),
                        onPressed: _signUp,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        color: Theme.of(context).primaryColor,
                      )
                    ],
                  ),
                ))));
  }

  void _signUp() {
    if(_SignUpFormGlobalKey.currentState.validate()){
      _SignUpFormGlobalKey.currentState.save();
    }
  }

  String emailValidator(input){
    final String pattern = r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
    final RegExp regExp = new RegExp(pattern);

    if(regExp.hasMatch(input)){
      return null;
    }
    return null;
  }
}
