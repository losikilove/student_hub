
import 'package:student_hub/utils/api_util.dart';
import 'package:http/http.dart' as http;
class MessageService{
  static const String _baseUrl = '${ApiUtil.baseUrl}/message';

 	
///api/message/{projectId}
  static Future<http.Response> getMessages({required String token, required int? companyID}) {
    String url = '$_baseUrl/messages/$companyID';
    return http.get(Uri.parse(url), headers: ApiUtil.getHeadersWithToken(token));
  }

 	
  //api/message/{projectId}/user/{userId}
  static Future<http.Response> getMessagesByUser({required String token, required int? companyID, required int? userID}) {
    String url = '$_baseUrl/messages/$companyID/user/$userID';
    return http.get(Uri.parse(url), headers: ApiUtil.getHeadersWithToken(token));
  }
  
  //api/message-get all message of login user (tính theo projectId)
  static Future<http.Response> sendMessage({required String token}) {
    String url = '$_baseUrl';
    return http.get(Uri.parse(url),
        headers: ApiUtil.getHeadersWithToken(token),
    );
  }
}