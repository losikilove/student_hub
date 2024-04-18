class EducationModel {
  final int? id;
  String _schoolName;
  int _beginningOfSchoolYear;
  int _endOfSchoolYear;

  EducationModel(this.id, this._schoolName, this._beginningOfSchoolYear,
      this._endOfSchoolYear);

  static List<EducationModel> fromResponse(List<dynamic> educationsResponse) {
    return educationsResponse
        .map(
          (e) => EducationModel(
            e['id'] as int,
            e['schoolName'] as String,
            e['startYear'] as int,
            e['endYear'] as int,
          ),
        )
        .toList();
  }

   factory EducationModel.fromJson(Map<String, dynamic> json) {
    return EducationModel(
      json['id'],
      json['schoolName'],
      json['startYear'],
      json['endYear'],   
    );
  }

  String get getSchoolName => _schoolName;
  int get getBeginningOfSchoolYear => _beginningOfSchoolYear;
  int get getEndOfSchoolYear => _endOfSchoolYear;
  String get getSchoolYear => '$_beginningOfSchoolYear-$_endOfSchoolYear';

  set setSchoolName(String otherSchoolName) {
    _schoolName = otherSchoolName;
  }

  set setBeginningOfSchoolYear(int otherStartOfSchoolYear) {
    _beginningOfSchoolYear = otherStartOfSchoolYear;
  }

  set setEndOfSchoolYear(int otherEndOfSchoolYear) {
    _endOfSchoolYear = otherEndOfSchoolYear;
  }
}
