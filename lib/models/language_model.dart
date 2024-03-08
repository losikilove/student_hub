class LanguageModel {
  String _language;
  String _level;
  LanguageModel(this._language, this._level);

  String get getLanguage => _language;
  String get getLevel => _level;

  @override
  String toString() {
    return '$getLanguage: $getLevel';
  }

  set setLanguage(String anotherLanguage) {
    _language = anotherLanguage;
  }

  set setLevel(String anotherLevel) {
    _level = anotherLevel;
  }
}
