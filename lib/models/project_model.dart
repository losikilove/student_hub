import 'dart:convert';

import 'package:http/http.dart' as http;
class ProjectModel {
  final int id;
  final String title;
  final String description;
  final String companyId;
  final int projectScopeFlag;
  final int typeFlag;
  final String timeCreated;
  final int proposal;
  final int numberofStudent;

  ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.companyId,
    required this.projectScopeFlag,
    required this.typeFlag,
    required this.timeCreated,
    required this.proposal,
    required this.numberofStudent,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      companyId: json['companyID'],
      projectScopeFlag: json['projectScopeFlag'],
      typeFlag: json['typeFlag'],
      timeCreated: json['createdAt'],
      proposal: json['countProposals'],
      numberofStudent: json['numberOfStudents']
    );
  }
  static List<ProjectModel> fromResponse(http.Response response) {
  return (json.decode(response.body)['result'] as List<dynamic>)
      .map((element) => ProjectModel(
          id: element['id'] as int,
          title: element['title'] as String,
          description: element['description'] as String,
          companyId: element['companyId'] as String,
          projectScopeFlag: element['projectScopeFlag'] as int,
          typeFlag: element['typeFlag'] as int,
          timeCreated: element['createdAt'] as String,
          proposal: element['countProposals'] as int,
          numberofStudent: element['numberOfStudents'] as int
      ))
      .toList();  
  }
  static List<ProjectModel> fromFavoriteResponse(http.Response response) {
  return (json.decode(response.body)['result'] as List<dynamic>)
      .map((element) => ProjectModel(
          id: element['project']['id'] as int,
          title: element['project']['title'] as String,
          description: element['project']['description'] as String,
          companyId: element['project']['companyId'] as String,
          projectScopeFlag: element['project']['projectScopeFlag'] as int,
          typeFlag: element['project']['typeFlag'] as int,
          timeCreated: element['project']['createdAt'] as String,
          proposal: element['countProposals'] as int,
          numberofStudent: element['project']['numberOfStudents'] as int
      ))
      .toList();  
  }
}
