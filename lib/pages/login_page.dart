import 'package:flutter/material.dart';

import 'package:here_to_clean_v2/controls/sign_in_form.dart';
import 'package:here_to_clean_v2/controls/sign_up_form.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _SignUpFormGlobalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Here to Clean'),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.lock_open),
                  text: 'Sign In',
                ),
                Tab(
                  icon: Icon(Icons.add),
                  text: 'Sign up',
                )
              ],
            ),
          ),
          body: TabBarView(children: [
            SignInForm(),
            SignUpForm()
          ])),
    );
  }
}
