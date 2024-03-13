class ProjectModel {
  final String _title;
  final String _timeCreating;
  final List<String> _wishes;
  final bool isCompelte;
  final bool like;
  int _numberProposals;
  int _numberMessages;
  int _numberHires;

  ProjectModel(
    this._title,
    this._timeCreating,
    this._wishes,
    this.isCompelte,
    this.like,
    this._numberProposals,
    this._numberMessages,
    this._numberHires,
  );
  ProjectModel.origin():
    this._title = '',
    this._timeCreating = '',
    this._wishes = [],
    this.isCompelte = false,
    this.like = false,
    this._numberProposals = 0,
    this._numberMessages = 0,
    this._numberHires =  0;

  String get title => _title;
  String get timeCreating => _timeCreating;
  List<String> get wishes => _wishes;
  int get numberProposals => _numberProposals;
  int get numberMessages => _numberMessages;
  int get numberHires => _numberHires;
}
