import 'package:flutter/material.dart';
import 'package:here_to_clean_v2/controls/association_list_view.dart';

class AssociationsPage extends StatelessWidget{

  final String token;
  AssociationsPage({this.token});


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Liste des associations"),
      ),
      body: AssociationListView(token: this.token),
    );
  }



}
