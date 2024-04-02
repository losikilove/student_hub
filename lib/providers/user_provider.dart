import 'package:flutter/material.dart';
import 'package:student_hub/models/user_model.dart';
import 'package:student_hub/services/auth_service.dart';
import 'package:student_hub/utils/api_util.dart';
import 'package:student_hub/services/profile_service.dart';
import 'package:student_hub/models/company_model.dart';
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
  void signout() {
    _token = null;
    _user = null;
    notifyListeners();
  }
}
