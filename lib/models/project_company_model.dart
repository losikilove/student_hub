import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:student_hub/models/enums/enum_projectlenght.dart';
import 'package:student_hub/models/enums/enum_type_flag.dart';

class ProjectCompanyModel{
  String title;
  EnumProjectLenght projectScopeFlag;
  int numberofStudent;
  String description;
  EnumTypeFlag typeFlag;
  ProjectCompanyModel({
    required this.title,
    required this.projectScopeFlag ,
    required this.numberofStudent,
    required this.description,
    required this.typeFlag
  });
  
}
class ProjectMyCompanyModel{
  final int id;
  final DateTime createdAt;
  final String companyId;
  final EnumProjectLenght projectScopeFlag;
  final String title;
  final String description;
  final int numberOfStudents;
  final EnumTypeFlag typeFlag;
  final List<dynamic> proposals;
  final int countProposals;
  final int countMessages;
  final int countHired;

  ProjectMyCompanyModel({
    required this.id,
    required this.createdAt,
    required this.companyId,
    required this.projectScopeFlag,
    required this.title,
    required this.description,
    required this.numberOfStudents,
    required this.typeFlag,
    required this.proposals,
    required this.countProposals,
    required this.countMessages,
    required this.countHired,
  });

  static List<ProjectMyCompanyModel> fromResponse(http.Response response) {
  final List<dynamic> result = json.decode(response.body)['result'];
  return result.map((element) => ProjectMyCompanyModel(
    id: element['id'] as int,
    createdAt: DateTime.parse(element['createdAt'] as String),
    companyId: element['companyId'] as String,
    projectScopeFlag: EnumProjectLenght.toProjectLenght(element['projectScopeFlag'] as int),
    title: element['title'] as String,
    description: element['description'] as String,
    numberOfStudents: element['numberOfStudents'] as int,
    typeFlag: EnumTypeFlag.toTypeFlag(element['typeFlag'] as int),
    proposals: [], // Assuming proposals is always an empty list in the response
    countProposals: element['countProposals'] as int,
    countMessages: element['countMessages'] as int,
    countHired: element['countHired'] as int,
  )).toList();
}
}