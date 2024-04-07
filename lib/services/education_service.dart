import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:student_hub/models/education_model.dart';
import 'package:student_hub/utils/api_util.dart';

class EducationService {
  static const String _baseUrl = '${ApiUtil.baseUrl}/education';

  // cou (stands for: create or update) an education of student
  // create - when id of education is null
  // update - when id of education is not null
  static Future<http.Response> couEducation(
      {required String token,
      required int? studentId,
      required List<EducationModel> educations}) {
    String url = '$_baseUrl/updateByStudentId/${studentId.toString()}';
    return http.put(Uri.parse(url),
        headers: ApiUtil.getHeadersWithToken(token),
        body: jsonEncode(<String, dynamic>{
          'education': educations
              .map((education) => <String, dynamic>{
                    'id': education.id,
                    'schoolName': education.getSchoolName,
                    'startYear': education.getBeginningOfSchoolYear,
                    'endYear': education.getEndOfSchoolYear,
                  })
              .toList(),
        }));
  }
}
