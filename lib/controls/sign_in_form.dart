import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Future<void> _signIn() async {
    final FormState formState = _SignInFormGlobalKey.currentState;
    if (formState.validate()) {
      formState.save();
      print("_password" + _password);
      print("_email" + _email);
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _email.trim(), password: _password.trim());

        FirebaseAuth.instance.currentUser().then((usr) => usr.getIdToken().then(
            (fbToken) => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MainPage(token: fbToken.token)))));
      } catch (e) {
        print(e.message);
      }
    }
  }
}
