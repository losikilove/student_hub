import 'package:http/http.dart' as http;
import 'package:student_hub/utils/api_util.dart';

class TechStackService {
  static const String _baseUrl = '${ApiUtil.baseUrl}/techstack';

  // get all tech stack
  static Future<http.Response> getAllTeckStack() {
    const String url = '$_baseUrl/getAllTechStack';

    return http.get(Uri.parse(url));
  }
}
