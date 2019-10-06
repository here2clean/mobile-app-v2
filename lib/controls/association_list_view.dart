import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:here_to_clean_v2/controls/association_list_all.dart';
import 'package:here_to_clean_v2/httpClients/H2CHttpClient.dart';
import 'package:here_to_clean_v2/model/Association.dart';
import 'package:here_to_clean_v2/constants/h2c_api_routes.dart';




class AssociationListView extends StatefulWidget {
  final String token;

  AssociationListView({this.token});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AssociationListView(token: token);
  }
}

class _AssociationListView extends State<AssociationListView> {
  final String token;

  _AssociationListView({this.token});

  Future<List<Association>> fetchAssociations(H2CHttpClient client) async {
    final response =
        await client.get(H2CApiRoutes.getAllAssociations);

    if (response.statusCode == 200) {
      return compute(parseAssociations, response.body);
    } else {
      throw new Exception(response.statusCode);
    }
  }

  static List<Association> parseAssociations(String responseBody) {
    log(responseBody);
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Association>((json) => Association.fromJson(json)).toList();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Padding(
        child: FutureBuilder<List<Association>>(
          future: fetchAssociations(H2CHttpClient(token: token)),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return AssociationList(associations: snapshot.data, token: token );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      ),
    );
    ;
  }
}
