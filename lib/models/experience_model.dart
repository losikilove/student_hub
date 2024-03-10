
class ExperienceModel{
  String _tile;
  String _description;
  String _setTimeStart;
  String _setTimeEnd;
  String _setMonths;
  List<String> _skill;
  

  ExperienceModel(
    this._tile,
    this._description,
    this._setTimeStart,
    this._setTimeEnd,
    this._setMonths,
    this._skill
  );
  
  String get getTile => _tile;
  String get getDescription => _description;
  String get getTimeStart => _setTimeStart;
  String get getTimeEnd => _setTimeEnd;
  String get getMonths => _setMonths;
  String get getTime => '$_setTimeStart-$_setTimeEnd, $_setMonths';
  List<String> get getSkills => _skill;

  set setTile(String tile){
    _tile = tile;
  }

  set setDescription(String desciption){
    _description = desciption;
  }

  set setTimeStart(String timeStart){
    _setTimeStart = timeStart;
  }
  set setTimeEnd(String timeEnd){
    _setTimeEnd = timeEnd;
  }
  set setMonths(String months){
    _setMonths = months;
  }
  set setSelectSkill(List<String> skills){
    _skill = skills;
  }
}