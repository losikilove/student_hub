import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_hub/providers/user_provider.dart';
import 'package:student_hub/utils/api_util.dart';
import 'package:http/http.dart' as http;

class ProposalService {
  static const String _baseUrl = '${ApiUtil.baseUrl}/proposal';
  static Future<http.Response> getAllProjectMyStudent(
      {required BuildContext context}) {
    const String url = '$_baseUrl/project';
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    int? id = userProvider.user?.company!.id;
    final token = userProvider.token!;
    return http.get(
      Uri.parse("$url/$id"),
      headers: ApiUtil.getHeadersWithToken(token),
    );
  }
}
