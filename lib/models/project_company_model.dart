class ProjectCompanyModel{
  String title;
  int projectScopeFlag;
  int numberofStudent;
  String description;
  int typeFlag;
  ProjectCompanyModel({
    required this.title,
    required this.projectScopeFlag,
    required this.numberofStudent,
    required this.description,
    this.typeFlag = 0,
  });

}