import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  String? _token;

  // get token of user
  String? get token => _token;

  // sign in
  void signin(String token) {
    _token = token;
    notifyListeners();
  }

  // sign out
  void signout() {
    _token = null;
    notifyListeners();
  }
}
