import 'package:flutter/material.dart';
import 'package:student_hub/models/user_model.dart';
import 'package:student_hub/services/auth_service.dart';
import 'package:student_hub/utils/api_util.dart';

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

    // get response from me-API
    final response = await AuthService.me(token: token);

    // get result of me-API response-body
    final result = ApiUtil.getResult(response);

    // save the user from me-API
    _user = UserModel.fromJson(result);

    notifyListeners();
  }

  // sign out
  void signout() {
    _token = null;
    _user = null;
    notifyListeners();
  }
}
