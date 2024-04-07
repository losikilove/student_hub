import 'package:http/http.dart' as http;
import 'package:student_hub/utils/api_util.dart';

class ProjectService {
  static const String _baseUrl = '${ApiUtil.baseUrl}/project';

  //View the all project
  static Future<http.Response> viewProject() {
    const String url = _baseUrl;
    return http.get(Uri.parse(url));
  }
   static Future<http.Response> viewProjectDetail({required int id,required String token}) {
    String url = '$_baseUrl/$id';
    return http.get(
      Uri.parse(url),
      headers: ApiUtil.getHeadersWithToken(token),
    );
  }

}
