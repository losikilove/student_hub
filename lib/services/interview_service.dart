import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:student_hub/utils/api_util.dart';

class InterviewService {
  static const String _baseUrl = '${ApiUtil.baseUrl}/interview';

  static Future<http.Response> postInterview(
      {
      required String title,
      required DateTime dateStartInterview,
      required TimeOfDay timeStartInterview,
      required TimeOfDay timeEndInterview}) async {
      String timeMonth = dateStartInterview.month < 10 ? '0${dateStartInterview.month}' : '${dateStartInterview.month}';
      String timeDay = dateStartInterview.day < 10 ? '0${dateStartInterview.day}' : '${dateStartInterview.day}';
      String timeStartHour = timeStartInterview.hour < 10 ? '0${timeStartInterview.hour}' : '${timeStartInterview.hour}';
      String timeStartMinute = timeStartInterview.minute < 10 ? '0${timeStartInterview.minute}' : '${timeStartInterview.minute}';
      String timeEndHour = timeEndInterview.hour < 10 ? '0${timeEndInterview.hour}' : '${timeEndInterview.hour}';
      String timeEndMinute = timeEndInterview.minute < 10 ? '0${timeEndInterview.minute}' : '${timeEndInterview.minute}';      
    return http.post(Uri.parse(_baseUrl),headers: ApiUtil.headers,
        body: jsonEncode(<String, dynamic>{
          'title': title,
          'startTime': '${dateStartInterview.year}-$timeMonth-${timeDay}T$timeStartHour:$timeStartMinute:00Z',
          'endTime': '${dateStartInterview.year}-$timeMonth-${timeDay}T$timeEndHour:$timeEndMinute:00Z',
          "projectId": {},
          "senderId": {},
          "receiverId": {}
        }));
  }
}
