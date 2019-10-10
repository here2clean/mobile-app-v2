import 'dart:developer';

import 'package:http/http.dart' as http;

class H2CHttpClient extends http.BaseClient{
  final String token;
  final http.Client _inner  = http.Client();

  H2CHttpClient({this.token});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Authorization'] = 'Bearer '+ token;
    request.headers['content-type'] = "application/json; charset=utf-8";
    request.headers['Accept'] = "application/json; charset=utf-8";
    log(request.headers['Authorization']);
    return _inner.send(request);
  }
}