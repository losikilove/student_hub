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

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'fullname': String fullname,
        'techStackId': dynamic techStackId,
        'resume': dynamic resume,
        'transcript': dynamic transcript,
      } =>
        StudentModel(
          id: id,
          fullname: fullname,
          techStackId: techStackId,
          resume: resume,
          transcript: transcript,
        ),
      _ => throw const FormatException('Failed to load student model.'),
    };
  }
}
