import 'package:student_hub/models/enums/enum_status_flag.dart';

class CandidateModel {
  final int studentId;
  final String _fullname;
  final String _yearOfStudy = '';
  final String _techStack;
  final String _level = 'Excellent';
  final String _coverLetter;
  EnumStatusFlag _statusFlag;

  CandidateModel(
    this.studentId,
    this._fullname,
    this._techStack,
    this._coverLetter,
    this._statusFlag,
  );

  String get fullname => _fullname;
  String get yearOfStudy => _yearOfStudy;
  String get techStack => _techStack;
  String get level => _level;
  String get coverLetter => _coverLetter;
  EnumStatusFlag get statusFlag => _statusFlag;

  void changeHiredCandidate(EnumStatusFlag status) {
    if (status == EnumStatusFlag.waitting) {
      _statusFlag = EnumStatusFlag.offer;
    }
  }

  static List<CandidateModel> fromResponse(List<dynamic> items) {
    return items
        .map((e) => CandidateModel(
              e['student']['id'],
              e['student']['fullname'],
              e['student']['techStack']['name'],
              e['coverLetter'],
              EnumStatusFlag.toStatusFlag(e['statusFlag'] as int),
            ))
        .toList();
  }
}
