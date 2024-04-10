import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:student_hub/models/enums/enum_projectlenght.dart';
import 'package:student_hub/models/enums/enum_type_flag.dart';

class ProjectModel {
  final int id;
  final String title;
  final String description;
  final String companyId;
  final EnumProjectLenght projectScopeFlag;
  final EnumTypeFlag? typeFlag;
  final String timeCreated;
  final int proposal;
  final int numberofStudent;
  bool isFavorite;

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
    required this.isFavorite,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        companyId: json['companyID'],
        projectScopeFlag:
            EnumProjectLenght.toProjectLenght(json['projectScopeFlag'] as int),
        typeFlag: json['typeFlag'] == null
            ? null
            : EnumTypeFlag.toTypeFlag(json['typeFlag'] as int),
        timeCreated: json['createdAt'],
        proposal: json['countProposals'],
        isFavorite: json['isFavorite'],
        numberofStudent: json['numberOfStudents']);
  }
  static List<ProjectModel> fromResponse(http.Response response) {
    return (json.decode(response.body)['result'] as List<dynamic>)
        .map((element) => ProjectModel(
            id: element['projectId'] as int,
            title: element['title'] as String,
            description: element['description'] as String,
            companyId: element['companyId'] as String,
            projectScopeFlag: EnumProjectLenght.toProjectLenght(
                element['projectScopeFlag'] as int),
            typeFlag: element['typeFlag'] == null
                ? null
                : EnumTypeFlag.toTypeFlag(element['typeFlag'] as int),
            timeCreated: element['createdAt'] as String,
            isFavorite: element['isFavorite'] as bool,
            proposal: element['countProposals'] as int,
            numberofStudent: element['numberOfStudents'] as int))
        .toList();
  }

  static List<ProjectModel> fromFavoriteResponse(http.Response response) {
    return (json.decode(response.body)['result'] as List<dynamic>)
        .map((element) => ProjectModel(
            id: element['project']['id'] as int,
            title: element['project']['title'] as String,
            description: element['project']['description'] as String,
            companyId: element['project']['companyId'] as String,
            projectScopeFlag: EnumProjectLenght.toProjectLenght(
                element['project']['projectScopeFlag'] as int),
            typeFlag: element['project']['typeFlag'] == null
                ? null
                : EnumTypeFlag.toTypeFlag(
                    element['project']['typeFlag'] as int),
            timeCreated: element['project']['createdAt'] as String,
            proposal: element['project']['countProposals'] as int,
            isFavorite: true,
            numberofStudent: element['project']['numberOfStudents'] as int))
        .toList();
  }
  static ProjectModel fromDetailResponse(http.Response response) {
  final Map<String, dynamic> responseBody = json.decode(response.body);
  final Map<String, dynamic> projectData = responseBody['result']['project'];
  
  dynamic proposals = projectData['proposals'];
  int proposal;
  if (proposals is List && proposals.isEmpty) {
    // If 'proposals' is an empty array, set 'proposal' to 0 or handle it accordingly
    proposal = 0; // Or any other default value
  } else {
    // If 'proposals' is not an array or it's not empty, handle it accordingly
    proposal = int.tryParse(proposals.toString()) ?? 0;
    }
  
    return ProjectModel(
      id: projectData['id'] as int,
      title: projectData['title'] as String,
      description: projectData['description'] as String,
      companyId: projectData['companyId'] as String,
      projectScopeFlag: EnumProjectLenght.toProjectLenght(projectData['projectScopeFlag'] as int),
      typeFlag: projectData['typeFlag'] == null
        ? null
        : EnumTypeFlag.toTypeFlag(projectData['typeFlag'] as int),
      timeCreated: projectData['createdAt'] as String,
      isFavorite: true,
      proposal: proposal,
      numberofStudent: projectData['numberOfStudents'] as int,
    );
  }


}
