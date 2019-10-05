import 'package:flutter/material.dart';
import 'package:here_to_clean_v2/model/Association.dart';

class AssociationList extends StatelessWidget {
  final List<Association> associations;

  AssociationList({this.associations});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: associations.length,
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              Card(
                child: Row(
                  children: <Widget>[
                    (associations[index].urlImage != null
                        ? Image.network(associations[index].urlImage,
                            width: 150)
                        : Container(
                            decoration: BoxDecoration(color: Colors.green),
                            child: Image.asset('assets/logos/h2clogo.png'),
                            width: 150,
                          )),
                    Text(associations[index].name)
                  ],
                ),
              ),
            ],
          );
        });
  }
}
