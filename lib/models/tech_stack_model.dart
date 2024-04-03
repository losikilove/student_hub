import 'dart:convert';

import 'package:http/http.dart' as http;

class TechStackModel {
  final int _id;
  final String _name;

  TechStackModel(this._id, this._name);

  static List<TechStackModel> fromResponse(http.Response response) {
    return (json.decode(response.body)['result'] as List<dynamic>)
        .map((element) =>
            TechStackModel(element['id'] as int, element['name'] as String))
        .toList();
  }

  // getter
  int get id => _id;
  String get name => _name;

  @override
  String toString() => _name;
}
