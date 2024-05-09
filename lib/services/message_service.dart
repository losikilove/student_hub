import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:student_hub/providers/user_provider.dart';
import 'package:student_hub/utils/api_util.dart';
import 'package:http/http.dart' as http;

class MessageService {
  static const String _baseUrl = '${ApiUtil.baseUrl}/message';

  static Future<http.Response> getMessageUser(
      {required BuildContext context,
      required int? projectID,
      required int? userID}) {
    String url = '$_baseUrl/$projectID/user/$userID';
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final token = userProvider.token!;
    return http.get(Uri.parse(url),
        headers: ApiUtil.getHeadersWithToken(token));
  }

  //get all message,
  static Future<http.Response> getMessage({required BuildContext context}) {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final token = userProvider.token!;
    String url = '$_baseUrl';
    return http.get(
      Uri.parse(url),
      headers: ApiUtil.getHeadersWithToken(token),
    );
  }

  // send message
  static Future<http.Response> sendMessage({
    required BuildContext context,
    required int projectId,
    required int receiverId,
    required int senderId,
    required String content,
    int messageFlag = 0,
  }) {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final token = userProvider.token!;
    String url = '$_baseUrl/sendMessage';

    return http.post(
      Uri.parse(url),
      headers: ApiUtil.getHeadersWithToken(token),
      body: jsonEncode(
        <String, dynamic>{
          "projectId": projectId,
          "receiverId": receiverId,
          "senderId": senderId,
          "content": content,
          "messageFlag": 0,
        },
      ),
    );
  }
}
