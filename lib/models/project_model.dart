class ProjectModel {
  final String _title;
  final String _timeCreating;
  final List<String> _wishes;
  bool _isCompelte;
  bool _like;
  int _numberProposals;
  int _numberMessages;
  int _numberHires;

  ProjectModel(
    this._title,
    this._timeCreating,
    this._wishes,
    this._isCompelte,
    this._like,
    this._numberProposals,
    this._numberMessages,
    this._numberHires,
  );
  set setLike(bool flag){
    _like = flag;
  }

  String get title => _title;
  String get timeCreating => _timeCreating;
  List<String> get wishes => _wishes;
  bool get isCompelte => _isCompelte;
  bool get like => _like;
  int get numberProposals => _numberProposals;
  int get numberMessages => _numberMessages;
  int get numberHires => _numberHires;
}
