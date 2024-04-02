import 'dart:convert';

import 'package:http/http.dart';

enum StatusCode {
  ok(code: 200),
  created(code: 201),
  error(code: 400),
  forbidden(code: 403),
  notFound(code: 404),
  unprocessableEntity(code: 422);

  final int code;

  const StatusCode({required this.code});
}

class ApiUtil {
  static const port = 4400;
  static const ipAndroid = '10.0.2.2';
  static const ipIos = '10.0.2.1';
  static const baseUrl = 'http://34.16.137.128/api';

  // general headers
  static const headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };

  // headers with token
  static Map<String, String> getHeadersWithToken(String token) {
    return <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  // in case want to get result of response-body
  static Map<String, dynamic> getResult(Response response) {
    return getBody(response)['result'];
  }

  // in case want to get body of response
  static Map<String, dynamic> getBody(Response response) {
    return json.decode(response.body);
  }
}
