import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:student_hub/models/experience_model.dart';
import 'package:student_hub/utils/api_util.dart';

class ExperienceService {
  static const String _baseUrl = '${ApiUtil.baseUrl}/experience';

  // cou (stands for: create or update) an experience of student
  // create - when id of experience is null
  // update - when id of experience is not null
  static Future<http.Response> couExperience(
      {required String token,
      required int? studentId,
      required List<ExperienceModel> experiences}) {
    String url = '$_baseUrl/updateByStudentId/${studentId.toString()}';
    return http.put(Uri.parse(url),
        headers: ApiUtil.getHeadersWithToken(token),
        body: jsonEncode(<String, dynamic>{
          'experience': experiences
              .map((exp) => <String, dynamic>{
                    'id': exp.id,
                    'title': exp.getTile,
                    'startMonth':
                        '${exp.getMonthStart.toString().padLeft(2, '0')}-${exp.getYearStart.toString().padLeft(4, '0')}',
                    'endMonth':
                        '${exp.getMonthEnd.toString().padLeft(2, '0')}-${exp.getYearEnd.toString().padLeft(4, '0')}',
                    'description': exp.getDescription,
                    'skillSets':
                        exp.getSkills.map((skill) => skill.id).toList(),
                  })
              .toList(),
        }));
  }
}
