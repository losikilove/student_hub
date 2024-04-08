import 'package:student_hub/models/enums/enum_projectlenght.dart';

class ProjectCompanyModel{
  String title;
  EnumProjectLenght projectScopeFlag;
  int numberofStudent;
  String description;
  int typeFlag;
  ProjectCompanyModel({
    required this.title,
    required this.projectScopeFlag ,
    required this.numberofStudent,
    required this.description,
    this.typeFlag = 0,
  });

}