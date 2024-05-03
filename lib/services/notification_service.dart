import 'package:http/http.dart' as http;
import 'package:student_hub/utils/api_util.dart';

class NotificationService {
  static const String _baseUrl = 'https://api.studenthub.dev';

  // get all notification 
  static Future<http.Response> getNotification({required String receiverId,required String token}) {
   String url = '$_baseUrl/api/notification/getByReceiverId/$receiverId';

    return http.get(Uri.parse(url)
        , headers: ApiUtil.getHeadersWithToken(token));
  }
}