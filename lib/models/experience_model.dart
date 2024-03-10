
class ExperienceModel{
  String _tile;
  String _description;
  String _setTimeStart;
  String _setTimeEnd;
  String _setMonths;
  

  ExperienceModel(
    this._tile,
    this._description,
    this._setTimeStart,
    this._setTimeEnd,
    this._setMonths,
  );
  
  String get getTileProject => _tile;
  String get getDescription => _description;
  String get getTimeStart => _setTimeStart;
  String get getTimeEnd => _setTimeEnd;


  static String caculateSetMonths(String timeStart, String timeEnd){
    List<String> start = timeStart.split('/'); 
    List<String> end = timeEnd.split('/'); 
    int index;
    if(int.parse(end[1]) > int.parse(start[1])){
      index = 12 - (int.parse(end[1]) - int.parse(start[1])) + 1;
      return  index.toString() + ' months';
    }
    else{
      index = int.parse(end[0]) - int.parse(start[0]);
      return  index.toString() + ' months';
    }
  }

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
    List<String> start = _setTimeStart.split('/'); 
    List<String> end = _setTimeEnd.split('/'); 
    int index;
    if(int.parse(end[1]) > int.parse(start[1])){
      index = 12 - (int.parse(end[1]) - int.parse(start[1])) + 1;
      _setMonths = index.toString() + ' months';
    }
    else{
      index = int.parse(end[0]) - int.parse(start[0]);
      _setMonths = index.toString() + ' months';
    }
  }
}