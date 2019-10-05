import 'package:flutter/material.dart';
import 'package:here_to_clean_v2/model/Association.dart';

class DetailAssociationPage extends StatefulWidget{

  final String token;
  final Association association;

  DetailAssociationPage({this.token, this.association});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DetailAssociationPageState();
  }
}

class _DetailAssociationPageState extends State<DetailAssociationPage>{

  final String token;
  final Association association;

  _DetailAssociationPageState({this.token, this.association});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text(association.name),),
      body: Card()
      ,
    );
  }

}