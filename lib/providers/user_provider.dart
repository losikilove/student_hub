import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:student_hub/models/user_model.dart';
import 'package:student_hub/services/auth_service.dart';

class UserProvider with ChangeNotifier {
  String? _token;
  UserModel? _user;

  // get token of user
  String? get token => _token;
  // get user
  UserModel? get user => _user;

  // sign in
  void signin(String token) async {
    _token = token;

    // get me
    final response = await AuthService.me(token: token);
    Map<String, dynamic> body = json.decode(response.body);

    log('user_provider: ${body['result'].toString()}');
    notifyListeners();
  }

  // sign out
  void signout() {
    _token = null;
    notifyListeners();
  }
}
