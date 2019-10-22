import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './pages/login_page.dart';

void main() {
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => {runApp(MyApp())});
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Here to clean',
      theme: ThemeData(
          primaryColor: Colors.green,
          accentColor: Colors.teal,
          fontFamily: 'RobotoSlab'),
      home: LoginPage(),
    );
  }
}
