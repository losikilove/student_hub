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

class ProjectCompanySubmitedModel extends ProjectCompanyModel{
  final int projectId;
  final DateTime createdAt;
  final String companyId;
  ProjectCompanySubmitedModel({
    required this.companyId,
    required this.createdAt,
    required this.projectId,
    required String title,
    required EnumProjectLenght projectScopeFlag,
    required int numberofStudent,
    required String description,
    required EnumTypeFlag typeFlag
  }) : super(
    title: title,
    projectScopeFlag: projectScopeFlag,
    numberofStudent: numberofStudent,
    description: description,
    typeFlag: typeFlag
  );
  static ProjectCompanySubmitedModel fromJson(Map<String, dynamic> json) {
    return ProjectCompanySubmitedModel(
      projectId: json['id'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      companyId: json['companyId'] as String,
      title: json['title'] as String,
      projectScopeFlag: EnumProjectLenght.toProjectLenght(json['projectScopeFlag'] as int),
      numberofStudent: json['numberOfStudents'] as int,
      description: json['description'] as String,
      typeFlag: EnumTypeFlag.toTypeFlag(json['typeFlag'] != null ? json['typeFlag'] as int : 0),
    );
  }
}
class ProjectMyCompanyModel extends ProjectCompanyModel{
  final int projectId;
  final DateTime createdAt;
  final String companyId;
  final List<dynamic>? proposals;
  final int countProposals;
  final int countMessages;
  final int countHired;
  
  ProjectMyCompanyModel({
    required this.projectId,
    required this.createdAt,
    required this.companyId,
    required String title,
    required EnumProjectLenght projectScopeFlag,
    required int numberofStudent,
    required String description,
    required EnumTypeFlag typeFlag,
    required this.proposals,
    required this.countProposals,
    required this.countMessages,
    required this.countHired
  }) : super(
    title: title,
    projectScopeFlag: projectScopeFlag,
    numberofStudent: numberofStudent,
    description: description,
    typeFlag: typeFlag
  );

  static List<ProjectMyCompanyModel> fromResponse(http.Response response) {
  final List<dynamic> result = json.decode(response.body)['result'];
  return result.map((element) => ProjectMyCompanyModel(
    projectId: element['id'] as int,
    createdAt: DateTime.parse(element['createdAt'] as String),
    companyId: element['companyId'] as String,
    projectScopeFlag: EnumProjectLenght.toProjectLenght(element['projectScopeFlag'] as int),
    title: element['title'] as String,
    description: element['description'] as String,
    numberofStudent: element['numberOfStudents'] as int,
    typeFlag: EnumTypeFlag.toTypeFlag(element['typeFlag'] as int),
    proposals: [], // Assuming proposals is always an empty list in the response
    countProposals: element['countProposals'] as int,
    countMessages: element['countMessages'] as int,
    countHired: element['countHired'] as int,
  )).toList();
}
}