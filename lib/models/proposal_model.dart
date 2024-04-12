import 'dart:convert';

import 'package:student_hub/models/project_company_model.dart';
import 'package:http/http.dart' as http;
class ProposalStudent {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int projectId;
  final int studentId;
  final String coverLetter;
  final int statusFlag;
  final int disableFlag;
  final ProjectCompanySubmitedModel project;

  ProposalStudent({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.projectId,
    required this.studentId,
    required this.coverLetter,
    required this.statusFlag,
    required this.disableFlag,
    required this.project,
  });

  static List<ProposalStudent> fromResponse(http.Response response) {
    final List<dynamic> result = json.decode(response.body)['result'];
    return result.map((e) => ProposalStudent(
      coverLetter: e['coverLetter'] as String,
      createdAt: DateTime.parse(e['createdAt'] as String),
      disableFlag: e['disableFlag'] as int,
      id: e['id'] as int,
      projectId: e['projectId'] as int,
      statusFlag: e['statusFlag'] as int,
      studentId: e['studentId'] as int,
      updatedAt: DateTime.parse(e['updatedAt'] as String),
      project: ProjectCompanySubmitedModel.fromJson(e['project'] as Map<String, dynamic>),
    )).toList();
  }
}