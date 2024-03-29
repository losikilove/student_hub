import 'package:student_hub/models/company_model.dart';
import 'package:student_hub/models/student_model.dart';

class UserModel {
  final int userId;
  StudentModel? student;
  CompanyModel? company;

  UserModel({required this.userId, this.student, this.company});

  factory UserModel.fromJson(Map<String, dynamic> jsonUser) {
    return UserModel(
      userId: jsonUser['id'],
      student: jsonUser['student'] == null
          ? null
          : StudentModel.fromJson(jsonUser['student']),
      company: jsonUser['company'] == null
          ? null
          : CompanyModel.fromJson(jsonUser['company']),
    );
  }
}
