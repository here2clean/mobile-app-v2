import 'dart:developer';

import 'package:http/http.dart' as http;

class H2CTokenLessHttpClient extends http.BaseClient{
  final http.Client _inner  = http.Client();

  H2CTokenLessHttpClient();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['content-type'] = "application/json; charset=utf-8";
    request.headers['Accept'] = "application/json; charset=utf-8";

    return _inner.send(request);
  }
}