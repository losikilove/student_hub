class SkillSetModel {
  final int _id;
  final String _name;

  SkillSetModel(this._id, this._name);

  static List<SkillSetModel> fromResponse(List<dynamic> skillSetsResponse) {
    return skillSetsResponse
        .map((element) =>
            SkillSetModel(element['id'] as int, element['name'] as String))
        .toList();
  }

  factory SkillSetModel.fromJson(Map<String, dynamic> json) {
    return SkillSetModel(
      int.parse(json['id']),
      json['name'],   
    );
  }
  // getter
  int get id => _id;
  String get name => _name;

  @override
  String toString() => _name;
}
