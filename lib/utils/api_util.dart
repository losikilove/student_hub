import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:student_hub/components/popup_notification.dart';
import 'package:student_hub/providers/user_provider.dart';
import 'package:student_hub/utils/navigation_util.dart';

enum StatusCode {
  ok(code: 200),
  created(code: 201),
  error(code: 400),
  unauthorized(code: 401),
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
  static const baseUrl = 'https://3609-118-69-13-234.ngrok-free.app/api';
  static const websocketUrl = 'https://3609-118-69-13-234.ngrok-free.app/';

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

  // handle expired token
  static void handleExpiredToken({required BuildContext context}) async {
    // expired token
    // then switch to the sign in screen
    await popupNotification(
      context: context,
      type: NotificationType.error,
      content: 'Sign in timed out! Back to sign in',
      textSubmit: 'Sign in',
      submit: null,
    );

    // auto switch to the sign in screen
    // after expire token
    Provider.of<UserProvider>(context, listen: false).signout();
    NavigationUtil.toSignInScreen(context);
  }

  // handle other cases which concern status code
  static void handleOtherStatusCode({required BuildContext context}) {
    popupNotification(
      context: context,
      type: NotificationType.error,
      content: 'Something went wrong',
      textSubmit: 'Ok',
      submit: null,
    );
  }
}
