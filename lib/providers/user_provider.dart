import 'package:flutter/material.dart';
import 'package:student_hub/models/user_model.dart';
import 'package:student_hub/services/auth_service.dart';
import 'package:student_hub/utils/api_util.dart';
import 'package:student_hub/services/profile_service.dart';
import 'package:student_hub/models/company_model.dart';
class UserProvider with ChangeNotifier {
  String? _token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NzgsImZ1bGxuYW1lIjoiUGhhdCBCZWF1IiwiZW1haWwiOiJucXBoYXQyMEB2cC5maXR1cy5lZHUudm4iLCJyb2xlcyI6WyIxIl0sImlhdCI6MTcxMjA0NzM1NCwiZXhwIjoxNzEzMjU2OTU0fQ.fNwU7cyfvPe8t327OuiOcoovyXmhjLAAICRPvhLo9TI';
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
  Future<bool> updateProfileCompany({
    required String companyName,
    required String website,
    required String description,
    }) async {
    final response = await ProfileService.updateCompanyProfile(
      companyName: companyName,
      id: _user?.company?.id.toString() ?? '',
      website: website, 
      description: description, 
      token: _token!
    );

    if (response.statusCode == 200) {
      CompanyModel newCompanyProfile = CompanyModel(
        companyName:companyName, 
        website: website,
        id: _user?.company?.id ?? 0,
        size: _user!.company?.size ?? 0,
        description: description,
      );
      _user?.company = newCompanyProfile;
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }
  // sign out
  void signout() async {
    // call API logout
    await AuthService.signout(token: _token!);

    // set null for whole attributes
    _token = null;
    _user = null;
    notifyListeners();
  }
}
