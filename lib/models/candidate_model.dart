class CandidateModel {
  final String _fullname;
  final String _yearOfStudy;
  final String _profession;
  final String _level;
  final String _description;
  bool isHired;

  CandidateModel(this._fullname, this._yearOfStudy, this._profession,
      this._level, this._description, this.isHired);

  String get fullname => _fullname;
  String get yearOfStudy => _yearOfStudy;
  String get profession => _profession;
  String get level => _level;
  String get description => _description;

  void changeHiredCandidate() {
    isHired = !isHired;
  }
}
