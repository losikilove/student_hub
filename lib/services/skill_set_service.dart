import 'package:http/http.dart' as http;
import 'package:student_hub/utils/api_util.dart';

class SkillSetService {
  static const String _baseUrl = '${ApiUtil.baseUrl}/skillset';

  // get all skill set
  static Future<http.Response> getAllSkillSet() {
    const String url = '$_baseUrl/getAllSkillSet';

    return http.get(Uri.parse(url));
  }
}
