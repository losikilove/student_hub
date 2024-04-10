import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:student_hub/models/language_model.dart';
import 'package:student_hub/utils/api_util.dart';

class LanguageService {
  static const String _baseUrl = '${ApiUtil.baseUrl}/language';

  // cou (stands for: create or update) an language of student
  // create - when id of language is null
  // update - when id of language is not null
  static Future<http.Response> couLanguage(
      {required String token,
      required int? studentId,
      required List<LanguageModel> languages}) {
    String url = '$_baseUrl/updateByStudentId/$studentId';
    return http.put(Uri.parse(url),
        headers: ApiUtil.getHeadersWithToken(token),
        body: jsonEncode(<String, dynamic>{
          'languages': languages
              .map((language) => <String, dynamic>{
                    'id': language.id,
                    'languageName': language.getLanguage,
                    'level': language.getLevel,
                  })
              .toList(),
        }));
  }
}
