import 'package:student_hub/models/enums/enum_projectlenght.dart';
import 'package:student_hub/models/enums/enum_scopeProject.dart';

class ProjectCompanyModel{
  String title;
  EnumProjectLenght projectScopeFlag;
  int numberofStudent;
  String description;
  EnumScopeProject scropProject;
  ProjectCompanyModel({
    required this.title,
    required this.projectScopeFlag ,
    required this.numberofStudent,
    required this.description,
    required this.scropProject
  });

}