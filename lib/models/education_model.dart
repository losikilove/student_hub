class EducationModel {
  final int? id;
  String _schoolName;
  String _beginningOfSchoolYear;
  String _endOfSchoolYear;

  EducationModel(this.id, this._schoolName, this._beginningOfSchoolYear,
      this._endOfSchoolYear);

  String get getSchoolName => _schoolName;
  String get getBeginningOfSchoolYear => _beginningOfSchoolYear;
  String get getEndOfSchoolYear => _endOfSchoolYear;
  String get getSchoolYear => '$_beginningOfSchoolYear-$_endOfSchoolYear';

  set setSchoolName(String otherSchoolName) {
    _schoolName = otherSchoolName;
  }

  set setBeginningOfSchoolYear(String otherStartOfSchoolYear) {
    _beginningOfSchoolYear = otherStartOfSchoolYear;
  }

  set setEndOfSchoolYear(String otherEndOfSchoolYear) {
    _endOfSchoolYear = otherEndOfSchoolYear;
  }
}
