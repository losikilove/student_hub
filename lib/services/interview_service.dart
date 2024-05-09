import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:student_hub/providers/user_provider.dart';
import 'package:student_hub/utils/api_util.dart';

class InterviewService {
  static const String _baseUrl = '${ApiUtil.baseUrl}/interview';

  static Future<http.Response> postInterview({
    required BuildContext context,
    required String title,
    required String startTime,
    required String endTime,
    required int projectId,
    required int receiverId,
    required int senderId,
    required String meetingRoomId,
    String content = 'showInterview',
  }) async {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final token = userProvider.token!;

    return http.post(Uri.parse(_baseUrl),
        headers: ApiUtil.getHeadersWithToken(token),
        body: jsonEncode(<String, dynamic>{
          'title': title,
          'content': content,
          'startTime': startTime,
          'endTime': endTime,
          'projectId': projectId,
          'senderId': senderId,
          'receiverId': receiverId,
          'meeting_room_code': meetingRoomId,
          'meeting_room_id': meetingRoomId,
          'expired_at': endTime,
        }));
  }

  static Future<http.Response> updateInterview({
    required BuildContext context,
    required String title,
    required String startTime,
    required String endTime,
    required int interviewId,
  }) async {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final token = userProvider.token!;
    String url = '$_baseUrl/$interviewId';

    return http.patch(Uri.parse(url),
        headers: ApiUtil.getHeadersWithToken(token),
        body: jsonEncode(<String, dynamic>{
          'title': title,
          'startTime': startTime,
          'endTime': endTime,
        }));
  }

  static Future<http.Response> disableInterview({
    required BuildContext context,
    required int interviewId,
  }) async {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final token = userProvider.token!;
    String url = '$_baseUrl/$interviewId/disable';

    return http.patch(
      Uri.parse(url),
      headers: ApiUtil.getHeadersWithToken(token),
    );
  }
}
