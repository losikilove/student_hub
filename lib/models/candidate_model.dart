import 'package:student_hub/models/enums/enum_status_flag.dart';

class CandidateModel {
  final int proposalId;
  final int projectId;
  final int studentId;
  final int userId;
  final String _fullname;
  final String _yearOfStudy = '';
  final String _techStack;
  final String _level = 'Excellent';
  final String _coverLetter;
  EnumStatusFlag _statusFlag;

  CandidateModel(
    this.proposalId,
    this.projectId,
    this.studentId,
    this.userId,    
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
    _statusFlag = status;
  }

  static List<CandidateModel> fromResponse(List<dynamic> items) {
    return items
        .map((e) => CandidateModel(
              e['id'] as int,
              e['projectId'],
              e['student']['id'],
              e['student']['userId'],
              e['student']['user']['fullname'],
              e['student']['techStack']['name'],
              e['coverLetter'],
              EnumStatusFlag.toStatusFlag(e['statusFlag'] as int),
            ))
        .toList();
  }
}
