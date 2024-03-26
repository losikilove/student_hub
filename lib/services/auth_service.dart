import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:student_hub/utils/api_util.dart';

class AuthService {
  static Future<http.Response> signin({
    required String fullname,
    required String email,
    required String password,
    required List<String> roles,
  }) {
    const String url = '${ApiUtil.baseUrl}/auth/sign-up';

    return http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'email': email,
        'password': password,
        'fullName': fullname,
        'roles': roles,
      }),
    );
  }
}
