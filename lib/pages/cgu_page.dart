import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CGUPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: AppBar(
        title: Text("Condition Générale d'utilisation"),
      ),
      body: WebView(
        initialUrl: 'assets/web/cgu.html',
      )
      ,
    );
  }
}
