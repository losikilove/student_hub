import 'package:student_hub/models/account_model.dart';
import 'package:student_hub/models/enums/enum_user.dart';

class StudentModel extends AccountModel {
  dynamic techStackId;
  dynamic resume;
  dynamic transcript;

  StudentModel(
      {required super.id,
      required super.fullname,
      super.role = EnumUser.student,
      required this.techStackId,
      required this.resume,
      required this.transcript});

  factory StudentModel.fromJson(Map<String, dynamic> jsonStudent) {
    return StudentModel(
      id: jsonStudent['id'],
      fullname: jsonStudent['fullname'],
      techStackId: jsonStudent['techStackId'],
      resume: jsonStudent['resume'],
      transcript: jsonStudent['transcript'],
    );
  }
}
