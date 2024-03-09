
class ProjectModel{
  String _Tile;
  String _Description;
  String _SetTimeStart;
  String _SetTimeEnd;
  String _SetMonths;

  ProjectModel(
    this._Tile,
    this._Description,
    this._SetTimeStart,
    this._SetTimeEnd,
    this._SetMonths,
  );
  
  String get getTileProject => _Tile;
  String get getDescription => _Description;
  String get getTimeStart => _SetTimeStart;
  String get getTimeEnd => _SetTimeEnd;


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
    _Tile = tile;
  }

  set setDescription(String desciption){
    _Description = desciption;
  }

  set setTimeStart(String timeStart){
    _SetTimeStart = timeStart;
  }
  set setTimeEnd(String timeEnd){
    _SetTimeEnd = timeEnd;
  }
  set setMonths(String months){
    List<String> start = _SetTimeStart.split('/'); 
    List<String> end = _SetTimeEnd.split('/'); 
    int index;
    if(int.parse(end[1]) > int.parse(start[1])){
      index = 12 - (int.parse(end[1]) - int.parse(start[1])) + 1;
      _SetMonths = index.toString() + ' months';
    }
    else{
      index = int.parse(end[0]) - int.parse(start[0]);
      _SetMonths = index.toString() + ' months';
    }
  }
}