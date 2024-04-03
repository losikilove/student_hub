import 'dart:convert';

import 'package:http/http.dart' as http;

class SkillSetModel {
  final int _id;
  final String _name;

  SkillSetModel(this._id, this._name);

  static List<SkillSetModel> fromResponse(http.Response response) {
    return (json.decode(response.body)['result'] as List<dynamic>)
        .map((element) =>
            SkillSetModel(element['id'] as int, element['name'] as String))
        .toList();
  }

  // getter
  int get id => _id;
  String get name => _name;

  @override
  String toString() => _name;
}
