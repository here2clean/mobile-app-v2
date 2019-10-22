import 'package:flutter/material.dart';
import 'package:here_to_clean_v2/controls/association_detail_view.dart';
import 'package:here_to_clean_v2/model/Association.dart';
import 'package:here_to_clean_v2/model/volunteer.dart';

class DetailAssociationPage extends StatefulWidget {
  final String token;
  final Association association;
  final Volunteer volunteer;

  DetailAssociationPage({this.token, this.association, this.volunteer});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DetailAssociationPageState(
        association: association, token: token, volunteer: volunteer);
  }
}

class _DetailAssociationPageState extends State<DetailAssociationPage> {
  final Association association;
  final String token;
  final Volunteer volunteer;

  _DetailAssociationPageState({this.volunteer, this.association, this.token});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AssociationDetailView(
      association: association,
      token: token,
      volunteer: volunteer,
    );
  }
}
