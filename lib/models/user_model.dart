import 'package:student_hub/models/company_model.dart';
import 'package:student_hub/models/enums/enum_user.dart';
import 'package:student_hub/models/student_model.dart';

class UserModel {
  final int userId;
  String fullname;
  // determine the main role of user
  EnumUser priorityRole;
  StudentModel? student;
  CompanyModel? company;

  UserModel({
    required this.userId,
    required this.priorityRole,
    required this.fullname,
    this.student,
    this.company,
  });

  factory UserModel.fromJson(Map<String, dynamic> jsonUser) {
    return UserModel(
      userId: jsonUser['id'],
      priorityRole: EnumUser.toRole(int.parse(jsonUser['roles'][0])),
      fullname: jsonUser['fullname'],
      student: jsonUser['student'] == null
          ? null
          : StudentModel.fromJson(jsonUser['student']),
      company: jsonUser['company'] == null
          ? null
          : CompanyModel.fromJson(jsonUser['company']),
    );
  }

  void changeToRestRole() {
    priorityRole = getEnumRestRole;
  }

  EnumUser get getEnumRestRole =>
      priorityRole == EnumUser.company ? EnumUser.student : EnumUser.company;

  bool isNullPriorityRole() {
    if (priorityRole == EnumUser.student && student == null) {
      return true;
    }

    if (priorityRole == EnumUser.company && company == null) {
      return true;
    }

    return false;
  }

  bool isNullRestRole() {
    final restRole = getEnumRestRole;

    if (restRole == EnumUser.student && student == null) {
      return true;
    }

    if (restRole == EnumUser.company && company == null) {
      return true;
    }

    return false;
  }
}
