import 'package:flutter/material.dart';
import 'package:student_hub/models/enums/enum_numberpeople.dart';
import 'package:student_hub/models/user_model.dart';
import 'package:student_hub/services/auth_service.dart';
import 'package:student_hub/utils/api_util.dart';
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

  // create company profile
  void saveCompanyAfterCreatedCompanyProfile({
    required int id,
    required String companyName,
    required String website,
    required String description,
    required EnumNumberPeople size,
  }) async {
    _user?.company = CompanyModel(
      id: id,
      companyName: companyName,
      website: website,
      size: size,
      description: description,
    );
  }

  // update company profile
  void saveCompanyWhenUpdatedProfileCompany({
    required String companyName,
    required String website,
    required String description,
  }) async {
    _user?.company = CompanyModel(
      id: _user!.company!.id,
      companyName: companyName,
      website: website,
      size: _user!.company!.size,
      description: description,
    );
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
