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
      priorityRole: EnumUser.toRole(jsonUser['roles'][0]),
      fullname: jsonUser['fullname'],
      student: jsonUser['student'] == null
          ? null
          : StudentModel.fromJson(jsonUser['student']),
      company: jsonUser['company'] == null
          ? null
          : CompanyModel.fromJson(jsonUser['company']),
    );
  }
}
