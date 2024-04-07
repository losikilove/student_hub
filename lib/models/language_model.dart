class LanguageModel {
  final int? id;
  String _language;
  String _level;
  LanguageModel(this.id, this._language, this._level);

  String get getLanguage => _language;
  String get getLevel => _level;

  static List<LanguageModel> fromResponse(List<dynamic> languagesResponse) {
    return languagesResponse
        .map(
          (e) => LanguageModel(
            e['id'] as int,
            e['languageName'] as String,
            e['level'] as String,
          ),
        )
        .toList();
  }

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
