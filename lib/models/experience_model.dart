import 'package:student_hub/models/skill_set_model.dart';

class ExperienceModel {
  String _tile;
  String _description;
  int _yearStart;
  int _yearEnd;
  int _monthStart;
  int _monthEnd;
  List<SkillSetModel> _skills;

  ExperienceModel(this._tile, this._description, this._yearStart, this._yearEnd,
      this._monthStart, this._monthEnd, this._skills);

  String get getTile => _tile;
  String get getDescription => _description;
  int get getYearStart => _yearStart;
  int get getYearEnd => _yearEnd;
  int get getMonthStart => _monthStart;
  int get getMonthEnd => _monthEnd;
  String get getDuration =>
      '$_monthStart/$_yearStart-$_monthEnd/$_yearEnd, ${diffMonths()} months';
  List<SkillSetModel> get getSkills => _skills;

  set setTile(String tile) {
    _tile = tile;
  }

  set setDescription(String desciption) {
    _description = desciption;
  }

  set setYearStart(int yearStart) {
    _yearStart = yearStart;
  }

  set setYearEnd(int yearEnd) {
    _yearEnd = yearEnd;
  }

  set setMonthStart(int monthStart) {
    _monthStart = monthStart;
  }

  set setMonthEnd(int monthEnd) {
    _monthEnd = monthEnd;
  }

  set setSkills(List<SkillSetModel> skills) {
    _skills = skills;
  }

  int diffMonths() {
    int diffYears = _yearEnd - _yearStart;
    int diffMonths = _monthEnd - _monthStart;

    return diffYears < 0
        // invalid difference years
        ? -1
        : (diffYears * 12 + (diffMonths <= 0 ? 0 : diffMonths)) + 1;
  }
}
