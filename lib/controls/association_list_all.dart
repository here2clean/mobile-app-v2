import 'package:flutter/material.dart';
import 'package:here_to_clean_v2/model/Association.dart';
import 'package:here_to_clean_v2/model/volunteer.dart';
import 'package:here_to_clean_v2/pages/detail_association_page.dart';

class AssociationList extends StatelessWidget {
  final List<Association> associations;
  final String token;
  final Volunteer volunteer;

  AssociationList({this.associations, this.token, this.volunteer});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: associations.length,
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              GestureDetector(
                child: Card(
                  child: Container(
                    padding: EdgeInsets.all(5) ,
                    child: Row(
                      children: <Widget>[
                        (associations[index].urlImage != null
                            ? Image.network(associations[index].urlImage,
                            width: 150)
                            : Container(
                          decoration: BoxDecoration(color: Colors.green),
                          child: Image.asset('assets/logos/h2clogo.png', fit: BoxFit.cover,),
                          width: 150,
                        )),
                        Container(
                          child: Expanded(
                            child: Center(
                              child: Text(
                                associations[index].name,
                                softWrap: true,
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailAssociationPage(
                              association: associations[index], token: token, volunteer: volunteer ,)))
                },
              )
            ],
          );
        });
  }
}
