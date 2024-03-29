import 'dart:convert';
import 'package:student_hub/models/account_model.dart';
import 'package:student_hub/models/company_model.dart';
import 'package:student_hub/models/student_model.dart';

class UserModel {
  final String userId;
  List<AccountModel> roles;

  UserModel({required this.userId, required this.roles});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'user': String userId,
        'student': String jsonStudent,
        'company': String jsonCompany
      } =>
        UserModel(userId: userId, roles: [
          StudentModel.fromJson(jsonDecode(jsonStudent)),
          CompanyModel.fromJson(jsonDecode(jsonCompany)),
        ]),
      _ => throw const FormatException('Failed to load user model.'),
    };
  }
}
