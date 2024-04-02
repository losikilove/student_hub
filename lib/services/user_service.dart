import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:student_hub/utils/api_util.dart';

class UserService {
  static const String _baseUrl = '${ApiUtil.baseUrl}/user';

  // change password
  static Future<http.Response> changePassword({
    required String token,
    required String oldPassword,
    required String newPassword,
  }) {
    String url = '$_baseUrl/changePassword';

    return http.put(
      Uri.parse(url),
      headers: ApiUtil.getHeadersWithToken(token),
      body: jsonEncode(<String, dynamic>{
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      }),
    );
  }
}
