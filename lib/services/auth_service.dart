import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:student_hub/providers/user_provider.dart';
import 'dart:convert';

import 'package:student_hub/utils/api_util.dart';

class AuthService {
  static const String _baseUrl = '${ApiUtil.baseUrl}/auth';

  // sign in
  static Future<http.Response> signin({
    required String email,
    required String password,
  }) {
    const String url = '$_baseUrl/sign-in';

    return http.post(
      Uri.parse(url),
      headers: ApiUtil.headers,
      body: jsonEncode(<String, dynamic>{
        'email': email,
        'password': password,
      }),
    );
  }

  // info user
  static Future<http.Response> me({required String token}) {
    const String url = '$_baseUrl/me';

    return http.get(
      Uri.parse(url),
      headers: ApiUtil.getHeadersWithToken(token),
    );
  }

  // sign out
  static Future<http.Response> signout({
    required String token,
    required BuildContext context,
  }) {
    const String url = '$_baseUrl/logout';

    Provider.of<UserProvider>(context, listen: false).signout();

    return http.post(
      Uri.parse(url),
      headers: ApiUtil.getHeadersWithToken(token),
    );
  }

  // sign up
  static Future<http.Response> signup({
    required String fullname,
    required String email,
    required String password,
    required int role,
  }) {
    const String url = '$_baseUrl/sign-up';

    return http.post(
      Uri.parse(url),
      headers: ApiUtil.headers,
      body: jsonEncode(<String, dynamic>{
        'email': email,
        'password': password,
        'fullName': fullname,
        'role': role,
      }),
    );
  }
}
