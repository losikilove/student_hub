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