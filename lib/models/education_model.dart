class EducationModel {
  String _schoolName;
  int _beginningOfSchoolYear;
  int _endOfSchoolYear;

  EducationModel(
      this._schoolName, this._beginningOfSchoolYear, this._endOfSchoolYear);

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
